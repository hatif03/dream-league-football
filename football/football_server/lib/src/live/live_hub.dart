import 'dart:convert';

import 'package:serverpod/serverpod.dart';

/// Who is connected to the live channel (`/live`), so endpoints can tell a player's browser that
/// something changed instead of the browser asking again and again.
///
/// ponytail: sockets are held in this server instance's memory. With more than one instance, events
/// would have to travel through Serverpod's message central or Redis; one instance covers this game.
class LiveHub {
  final _sockets = <String, Set<RelicWebSocket>>{};

  /// Most live connections one player may hold (extra browser tabs); the oldest is closed beyond it.
  static const maxPerUser = 4;

  Future<void> add(String userId, RelicWebSocket ws) async {
    final set = _sockets.putIfAbsent(userId, () => <RelicWebSocket>{});
    set.add(ws);
    while (set.length > maxPerUser) {
      final oldest = set.first;
      set.remove(oldest);
      await oldest.tryClose(1000, 'too many connections');
    }
  }

  void remove(String userId, RelicWebSocket ws) {
    final set = _sockets[userId];
    if (set == null) return;
    set.remove(ws);
    if (set.isEmpty) _sockets.remove(userId);
  }

  bool isConnected(String userId) => (_sockets[userId]?.isNotEmpty ?? false);

  int get connections => _sockets.values.fold(0, (a, s) => a + s.length);

  /// Tells each of [userIds] (nulls and duplicates are skipped) that [topic] changed.
  /// Topics: friends, lobby, chat, match, duel, queue. [id] is the room or match concerned.
  void notify(Iterable<String?> userIds, String topic, [String? id]) {
    final text = jsonEncode({'t': topic, if (id != null) 'id': id});
    for (final u in userIds.whereType<String>().toSet()) {
      final set = _sockets[u];
      if (set == null) continue;
      for (final ws in set.toList()) {
        ws.trySendText(text);
      }
    }
  }
}

/// The one hub of this server.
final liveHub = LiveHub();
