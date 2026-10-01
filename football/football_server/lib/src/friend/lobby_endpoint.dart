import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../data/world_cup_data.dart';
import '../generated/protocol.dart';
import '../social/social_util.dart';
import '../util/rate_limit.dart';

const _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const _lobbyIdle = Duration(hours: 3);

class LobbyEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _rng = Random.secure();

  String _newCode() => List.generate(5, (_) => _codeChars[_rng.nextInt(_codeChars.length)]).join();

  /// Opens a room; the caller is the host (their browser runs the simulation).
  Future<LobbyView> create(Session session, String clientVersion) async {
    final profile = await requireProfile(session);
    rateLimit(profile.userId, 'lobby.create', max: 6);
    await assertNotInMaintenance(session);
    await _closeStaleRooms(session, profile.userId);
    for (var i = 0; i < 5; i++) {
      final code = _newCode();
      if (await Lobby.db.findFirstRow(session, where: (l) => l.code.equals(code)) != null) continue;
      final lobby = await Lobby.db.insertRow(
        session,
        Lobby(
          code: code,
          hostUserId: profile.userId,
          hostReady: false,
          guestReady: false,
          status: 'open',
          clientVersion: clientVersion,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      return _view(session, lobby, profile.userId);
    }
    throw GameException(message: 'Could not create a room. Try again.');
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
    return _view(session, lobby, profile.userId);
  }

  /// The current state of a room, for polling.
  Future<LobbyView> get(Session session, UuidValue lobbyId) async {
    final userId = requireUserId(session);
    return _view(session, await _read(session, lobbyId, userId), userId);
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
    return _view(session, lobby, userId);
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
        final match = await FriendMatch.db.insertRow(
          session,
          FriendMatch(
            lobbyId: l.id!,
            hostUserId: l.hostUserId,
            guestUserId: l.guestUserId,
            hostNation: l.hostNation!,
            guestNation: l.guestNation!,
            status: 'live',
          ),
          transaction: tx,
        );
        l
          ..matchId = match.id
          ..status = 'live';
      }
      return Lobby.db.updateRow(session, l, transaction: tx);
    });
    return _view(session, lobby, userId);
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
          code: await _freeCode(session, tx),
          hostUserId: old.guestUserId!,
          guestUserId: old.hostUserId,
          hostNation: old.guestNation,
          guestNation: old.hostNation,
          hostReady: false,
          guestReady: false,
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
    return _view(session, fresh!, userId);
  }

  Future<String> _freeCode(Session session, Transaction tx) async {
    for (var i = 0; i < 5; i++) {
      final code = _newCode();
      if (await Lobby.db.findFirstRow(session, where: (l) => l.code.equals(code), transaction: tx) == null) {
        return code;
      }
    }
    throw GameException(message: 'Could not create a room. Try again.');
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
  ) {
    return session.db.transaction((tx) async {
      final l = _checkMine(
        await Lobby.db.findById(session, id, transaction: tx, lockMode: LockMode.forUpdate),
        userId,
      );
      change(l);
      l.updatedAt = DateTime.now().toUtc();
      return Lobby.db.updateRow(session, l, transaction: tx);
    });
  }

  Future<String> _name(Session session, String userId) async {
    final p = await UserProfile.db.findFirstRow(session, where: (t) => t.userId.equals(userId));
    return p?.displayName ?? 'Removed player';
  }

  Future<LobbyView> _view(Session session, Lobby lobby, String userId) async {
    return LobbyView(
      lobby: lobby,
      hostName: await _name(session, lobby.hostUserId),
      guestName: lobby.guestUserId == null ? null : await _name(session, lobby.guestUserId!),
      youAreHost: lobby.hostUserId == userId,
    );
  }
}
