import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import 'live_hub.dart';

const _authWindow = Duration(seconds: 8);

/// A WebSocket at `/live` that pushes "something changed" events to a signed-in player (friend
/// requests and invites, the other player joining or leaving a room, a kick in a penalty duel, a
/// matchmaking match...). The browser then refetches just that thing, so it needs far fewer polls.
///
/// Serverpod's own streaming endpoints are only reachable with its generated Dart client, so the
/// web app gets this small socket instead, authenticated with the same JWT as every endpoint:
/// the first frame must be `{"token": jwt}`.
class LiveRoute extends Route {
  LiveRoute(this._auth) : super(methods: {Method.get}, path: '/live');

  final AuthenticationHandler _auth;

  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    return WebSocketUpgrade(allowAnyOrigin: true, (ws) async {
      ws.pingInterval = const Duration(seconds: 25);
      final events = StreamIterator(ws.events);
      String? userId;
      try {
        final first = await _firstText(events).timeout(_authWindow);
        userId = await _admit(session, first);
        if (userId == null) {
          await ws.tryClose(4003, 'not allowed');
          return;
        }
        await liveHub.add(userId, ws);
        ws.trySendText(jsonEncode({'live': 'ok'}));
        // The browser only listens; anything it sends is ignored (a text "ping" is answered).
        while (await events.moveNext()) {
          final e = events.current;
          if (e is TextDataReceived && e.text == 'ping') ws.trySendText('pong');
        }
      } on TimeoutException {
        await ws.tryClose(4008, 'auth timeout');
      } finally {
        await events.cancel();
        if (userId != null) liveHub.remove(userId, ws);
      }
    });
  }

  Future<String> _firstText(StreamIterator<WebSocketEvent> events) async {
    while (await events.moveNext()) {
      final e = events.current;
      if (e is TextDataReceived) return e.text;
    }
    throw TimeoutException('closed before auth');
  }

  Future<String?> _admit(Session session, String first) async {
    try {
      final token = (jsonDecode(first) as Map)['token'] as String?;
      if (token == null) return null;
      final info = await _auth(session, token);
      return info?.userIdentifier;
    } catch (_) {
      return null;
    }
  }
}
