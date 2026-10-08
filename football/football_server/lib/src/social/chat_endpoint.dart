import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../generated/protocol.dart';
import '../live/live_hub.dart';
import '../util/rate_limit.dart';
import 'social_util.dart';

class ChatEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Posts a line in a room the caller is in.
  Future<void> send(Session session, UuidValue lobbyId, String text) async {
    final profile = await requireProfile(session);
    rateLimit(profile.userId, 'chat.send', max: 8, window: const Duration(seconds: 10));
    await _assertMember(session, lobbyId, profile.userId);
    final clean = cleanChat(text.trim());
    if (clean.isEmpty) return;
    if (clean.length > 200) throw GameException(message: 'Keep it under 200 characters.');
    await LobbyMessage.db.insertRow(
      session,
      LobbyMessage(lobbyId: lobbyId, userId: profile.userId, text: clean),
    );
    final lobby = await Lobby.db.findById(session, lobbyId);
    if (lobby != null) liveHub.notify([lobby.hostUserId, lobby.guestUserId], 'chat', lobbyId.toString());
  }

  /// The latest lines of a room, oldest first. Lines from players the caller blocked are hidden.
  Future<List<ChatLine>> list(Session session, UuidValue lobbyId) async {
    final me = requireUserId(session);
    await _assertMember(session, lobbyId, me);
    final rows = await LobbyMessage.db.find(
      session,
      where: (m) => m.lobbyId.equals(lobbyId),
      orderBy: (m) => m.createdAt.desc(),
      limit: 50,
    );
    final blocks = await UserBlock.db.find(session, where: (b) => b.userId.equals(me));
    final hidden = {for (final b in blocks) b.blockedUserId};
    final out = <ChatLine>[];
    for (final m in rows.reversed) {
      if (hidden.contains(m.userId)) continue;
      out.add(
        ChatLine(
          id: m.id!,
          userId: m.userId,
          name: await displayNameOf(session, m.userId),
          text: m.text,
          createdAt: m.createdAt,
        ),
      );
    }
    return out;
  }

  Future<void> _assertMember(Session session, UuidValue lobbyId, String userId) async {
    final lobby = await Lobby.db.findById(session, lobbyId);
    if (lobby == null || (lobby.hostUserId != userId && lobby.guestUserId != userId)) {
      throw GameException(message: 'Room not found.');
    }
  }
}
