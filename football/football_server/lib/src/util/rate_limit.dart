import '../generated/protocol.dart';

final _hits = <String, List<DateTime>>{};

/// Allows [max] calls per [window] for this user and [action], or throws.
// ponytail: in-memory, so per server instance; move to the database if the app scales out.
void rateLimit(String userId, String action, {int max = 10, Duration window = const Duration(minutes: 1)}) {
  final now = DateTime.now();
  final list = _hits.putIfAbsent('$userId:$action', () => []);
  list.removeWhere((t) => now.difference(t) > window);
  if (list.length >= max) {
    throw GameException(message: 'Slow down a little and try again.');
  }
  list.add(now);
}
