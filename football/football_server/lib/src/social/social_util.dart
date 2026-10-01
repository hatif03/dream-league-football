import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Display name for a user id, or "Removed player" once the account is gone.
Future<String> displayNameOf(Session session, String? userId) async {
  if (userId == null) return 'Removed player';
  final p = await UserProfile.db.findFirstRow(session, where: (t) => t.userId.equals(userId));
  return p?.displayName ?? 'Removed player';
}

/// A player is "online" while their app keeps checking in (see FriendsEndpoint.list).
const onlineWindow = Duration(seconds: 75);

Future<PersonView> personOf(Session session, String userId) async {
  final p = await UserProfile.db.findFirstRow(session, where: (t) => t.userId.equals(userId));
  final seen = p?.lastSeenAt;
  final online = seen != null && DateTime.now().toUtc().difference(seen) < onlineWindow;
  return PersonView(userId: userId, name: p?.displayName ?? 'Removed player', online: online);
}

/// True if either player has blocked the other.
Future<bool> isBlockedEitherWay(Session session, String a, String b) async {
  final n = await UserBlock.db.count(
    session,
    where: (t) =>
        (t.userId.equals(a) & t.blockedUserId.equals(b)) | (t.userId.equals(b) & t.blockedUserId.equals(a)),
  );
  return n > 0;
}

/// Whether the game is in maintenance (no new rooms). Sign-in and running matches are unaffected.
Future<LiveStatus> liveStatus(Session session) async {
  final row = await LiveOps.db.findFirstRow(session);
  return LiveStatus(maintenance: row?.maintenance ?? false, message: row?.message);
}

Future<void> assertNotInMaintenance(Session session) async {
  final s = await liveStatus(session);
  if (s.maintenance) {
    throw GameException(message: s.message ?? 'New rooms are paused for maintenance. Try again soon.');
  }
}

// ponytail: a short word list; swap in a proper filter service if chat becomes busy.
const _blocked = ['fuck', 'shit', 'cunt', 'bitch', 'nigger', 'nigga', 'faggot', 'retard', 'whore', 'slut'];

/// Masks listed words (also when letters are split by spaces or symbols).
String cleanChat(String text) {
  var out = text;
  for (final w in _blocked) {
    final pattern = w.split('').map(RegExp.escape).join(r'[\s._*-]*');
    out = out.replaceAllMapped(RegExp(pattern, caseSensitive: false), (m) => '*' * m.group(0)!.length);
  }
  return out;
}
