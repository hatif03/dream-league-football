import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../data/world_cup_data.dart';
import '../generated/protocol.dart';
import '../live/live_hub.dart';
import '../social/social_util.dart';
import '../util/rate_limit.dart';
import 'penalty_duel.dart';

const _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const _lobbyIdle = Duration(hours: 3);
const roomModes = {'match', 'penalties'};

final _rng = Random.secure();
String _newCode() => List.generate(5, (_) => _codeChars[_rng.nextInt(_codeChars.length)]).join();

/// A room code nobody else holds.
Future<String> freeRoomCode(Session session, {Transaction? tx}) async {
  for (var i = 0; i < 5; i++) {
    final code = _newCode();
    if (await Lobby.db.findFirstRow(session, where: (l) => l.code.equals(code), transaction: tx) == null) {
      return code;
    }
  }
  throw GameException(message: 'Could not create a room. Try again.');
}

/// Creates the match row for a room whose two players are both ready, and opens the first kick if it is a
/// penalty duel. Must run in the transaction that holds the room's lock. Marks the room live.
Future<FriendMatch> startMatchFor(Session session, Transaction tx, Lobby l) async {
  final match = await FriendMatch.db.insertRow(
    session,
    FriendMatch(
      lobbyId: l.id!,
      hostUserId: l.hostUserId,
      guestUserId: l.guestUserId,
      hostNation: l.hostNation!,
      guestNation: l.guestNation!,
      mode: l.mode,
      status: 'live',
    ),
    transaction: tx,
  );
  if (l.mode == 'penalties') await startDuel(session, tx, match);
  l
    ..matchId = match.id
    ..status = 'live';
  return match;
}

Future<String> _nameOf(Session session, String userId) async {
  final p = await UserProfile.db.findFirstRow(session, where: (t) => t.userId.equals(userId));
  return p?.displayName ?? 'Removed player';
}

/// A room as one of its players sees it.
Future<LobbyView> buildLobbyView(Session session, Lobby lobby, String userId) async {
  return LobbyView(
    lobby: lobby,
    hostName: await _nameOf(session, lobby.hostUserId),
    hostAvatar: await avatarOf(session, lobby.hostUserId),
    guestAvatar: await avatarOf(session, lobby.guestUserId),
    guestName: lobby.guestUserId == null ? null : await _nameOf(session, lobby.guestUserId!),
    youAreHost: lobby.hostUserId == userId,
  );
}

/// Tells the room's players that it changed.
void notifyLobby(Lobby l) => liveHub.notify([l.hostUserId, l.guestUserId], 'lobby', l.id.toString());

class LobbyEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Opens a room; the caller is the host (their browser runs the simulation of a full match).
  /// [mode] is `match` (the default) or `penalties`, a penalty duel the server referees.
  Future<LobbyView> create(Session session, String clientVersion, String? mode) async {
    final profile = await requireProfile(session);
    rateLimit(profile.userId, 'lobby.create', max: 6);
    await assertNotInMaintenance(session);
    final roomMode = mode ?? 'match';
    if (!roomModes.contains(roomMode)) throw GameException(message: 'Unknown game mode.');
    await _closeStaleRooms(session, profile.userId);
    final lobby = await Lobby.db.insertRow(
      session,
      Lobby(
        code: await freeRoomCode(session),
        hostUserId: profile.userId,
        hostReady: false,
        guestReady: false,
        mode: roomMode,
        status: 'open',
        clientVersion: clientVersion,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    return buildLobbyView(session, lobby, profile.userId);
  }

  /// Joins an open room by its code as the guest.
  Future<LobbyView> join(Session session, String code, String clientVersion) async {
    final profile = await requireProfile(session);
    rateLimit(profile.userId, 'lobby.join', max: 20);
    await assertNotInMaintenance(session);
    final lobby = await session.db.transaction((tx) async {
      final l = await Lobby.db.findFirstRow(
        session,
        where: (l) => l.code.equals(code.trim().toUpperCase()),
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (l == null || _expired(l) || l.status != 'open') {
        throw GameException(message: 'No open room with that code.');
      }
      if (l.hostUserId == profile.userId) return l;
      if (await isBlockedEitherWay(session, l.hostUserId, profile.userId)) {
        throw GameException(message: 'No open room with that code.');
      }
      if (l.guestUserId != null && l.guestUserId != profile.userId) {
        throw GameException(message: 'That room is full.');
      }
      if (l.clientVersion != clientVersion) {
        throw GameException(
          message: 'Your game version differs from the host. Refresh the page and try again.',
        );
      }
      l
        ..guestUserId = profile.userId
        ..updatedAt = DateTime.now().toUtc();
      await LobbyInvite.db.deleteWhere(
        session,
        where: (i) => i.lobbyId.equals(l.id!) & i.toUserId.equals(profile.userId),
        transaction: tx,
      );
      return Lobby.db.updateRow(session, l, transaction: tx);
    });
    notifyLobby(lobby);
    liveHub.notify([profile.userId], 'friends');
    return buildLobbyView(session, lobby, profile.userId);
  }

  /// The current state of a room, for polling.
  Future<LobbyView> get(Session session, UuidValue lobbyId) async {
    final userId = requireUserId(session);
    return buildLobbyView(session, await _read(session, lobbyId, userId), userId);
  }

  Future<LobbyView> setNation(Session session, UuidValue lobbyId, String nationId) async {
    final userId = requireUserId(session);
    if (!wcNations.containsKey(nationId)) throw GameException(message: 'Unknown nation.');
    final lobby = await _update(session, lobbyId, userId, (l) {
      if (l.status != 'open') throw GameException(message: 'This room is closed.');
      final isHost = l.hostUserId == userId;
      if ((isHost ? l.guestNation : l.hostNation) == nationId) {
        throw GameException(message: 'The two nations must be different.');
      }
      if (isHost) {
        l
          ..hostNation = nationId
          ..hostReady = false;
      } else {
        l
          ..guestNation = nationId
          ..guestReady = false;
      }
    });
    return buildLobbyView(session, lobby, userId);
  }

  /// Marks the caller ready. When both are ready the match row is created.
  Future<LobbyView> setReady(Session session, UuidValue lobbyId, bool ready) async {
    final userId = requireUserId(session);
    final lobby = await session.db.transaction((tx) async {
      final l = _checkMine(
        await Lobby.db.findById(session, lobbyId, transaction: tx, lockMode: LockMode.forUpdate),
        userId,
      );
      if (l.status != 'open') throw GameException(message: 'This room is closed.');
      final isHost = l.hostUserId == userId;
      if (ready && (isHost ? l.hostNation : l.guestNation) == null) {
        throw GameException(message: 'Pick a nation first.');
      }
      if (isHost) {
        l.hostReady = ready;
      } else {
        l.guestReady = ready;
      }
      l.updatedAt = DateTime.now().toUtc();

      if (l.hostReady && l.guestReady && l.guestUserId != null) {
        if (l.hostNation == l.guestNation) {
          throw GameException(message: 'The two nations must be different.');
        }
        await startMatchFor(session, tx, l);
      }
      return Lobby.db.updateRow(session, l, transaction: tx);
    });
    notifyLobby(lobby);
    return buildLobbyView(session, lobby, userId);
  }

  /// Leaves the room. The host leaving closes it; a guest leaving frees the seat.
  Future<void> leave(Session session, UuidValue lobbyId) async {
    final userId = requireUserId(session);
    await _update(session, lobbyId, userId, (l) {
      if (l.status != 'open') return;
      if (l.hostUserId == userId) {
        l.status = 'closed';
      } else {
        l
          ..guestUserId = null
          ..guestNation = null
          ..guestReady = false
          ..hostReady = false;
      }
    });
  }

  /// Starts a rematch from a finished match: a fresh room, host and guest swapped,
  /// nations kept. Whichever player asks first creates it; the other gets the same room.
  Future<LobbyView> rematch(Session session, UuidValue lobbyId, String clientVersion) async {
    final userId = requireUserId(session);
    final fresh = await session.db.transaction((tx) async {
      final old = _checkMine(
        await Lobby.db.findById(session, lobbyId, transaction: tx, lockMode: LockMode.forUpdate),
        userId,
      );
      if (old.rematchLobbyId != null) {
        return Lobby.db.findById(session, old.rematchLobbyId!, transaction: tx);
      }
      if (old.status != 'live' || old.guestUserId == null) {
        throw GameException(message: 'There is no finished match to replay.');
      }
      final created = await Lobby.db.insertRow(
        session,
        Lobby(
          code: await freeRoomCode(session, tx: tx),
          hostUserId: old.guestUserId!,
          guestUserId: old.hostUserId,
          hostNation: old.guestNation,
          guestNation: old.hostNation,
          hostReady: false,
          guestReady: false,
          mode: old.mode,
          status: 'open',
          clientVersion: clientVersion,
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      );
      old
        ..rematchLobbyId = created.id
        ..updatedAt = DateTime.now().toUtc();
      await Lobby.db.updateRow(session, old, transaction: tx);
      return created;
    });
    notifyLobby(fresh!);
    return buildLobbyView(session, fresh, userId);
  }

  bool _expired(Lobby l) => DateTime.now().toUtc().difference(l.updatedAt) > _lobbyIdle;

  /// Closes the caller's old open rooms so a forgotten code cannot pile up.
  Future<void> _closeStaleRooms(Session session, String userId) async {
    final stale = await Lobby.db.find(
      session,
      where: (l) => l.hostUserId.equals(userId) & l.status.equals('open'),
    );
    for (final l in stale) {
      l.status = 'closed';
      await Lobby.db.updateRow(session, l);
    }
  }

  Lobby _checkMine(Lobby? l, String userId) {
    if (l == null || (l.hostUserId != userId && l.guestUserId != userId)) {
      throw GameException(message: 'Room not found.');
    }
    return l;
  }

  /// A room as its player sees it; an idle open room reads as closed.
  Future<Lobby> _read(Session session, UuidValue id, String userId) async {
    final l = _checkMine(await Lobby.db.findById(session, id), userId);
    if (l.status == 'open' && _expired(l)) l.status = 'closed';
    return l;
  }

  /// Read-modify-write under a row lock, so the two players never overwrite each other.
  Future<Lobby> _update(
    Session session,
    UuidValue id,
    String userId,
    void Function(Lobby l) change,
  ) async {
    final saved = await session.db.transaction((tx) async {
      final l = _checkMine(
        await Lobby.db.findById(session, id, transaction: tx, lockMode: LockMode.forUpdate),
        userId,
      );
      change(l);
      l.updatedAt = DateTime.now().toUtc();
      return Lobby.db.updateRow(session, l, transaction: tx);
    });
    notifyLobby(saved);
    return saved;
  }
}
