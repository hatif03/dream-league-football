import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// The signed-in user's auth id. Endpoints that call this set `requireLogin`.
String requireUserId(Session session) => session.authenticated!.userIdentifier;

/// The signed-in user's profile; throws if none exists yet or the user is banned.
Future<UserProfile> requireProfile(Session session) async {
  final profile = await UserProfile.db.findFirstRow(
    session,
    where: (t) => t.userId.equals(requireUserId(session)),
  );
  if (profile == null) {
    throw GameException(message: 'Choose a display name first.');
  }
  final ban = profile.bannedUntil;
  if (ban != null && ban.isAfter(DateTime.now().toUtc())) {
    throw GameException(message: 'This account is suspended.');
  }
  return profile;
}
