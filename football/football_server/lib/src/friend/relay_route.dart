import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

const _maxFrame = 64 * 1024;
const _authWindow = Duration(seconds: 8);

class _Room {
  RelicWebSocket? host;
  RelicWebSocket? guest;
  RelicWebSocket? peerOf(String role) => role == 'host' ? guest : host;
}

/// Fallback transport for a friend match whose two browsers cannot connect
/// directly: a WebSocket per player at `/relay/<matchId>` that forwards every text
/// frame to the other player, untouched. The first frame must be `{"token": jwt}`;
/// only the two players of a live match are let in.
class RelayRoute extends Route {
  RelayRoute(this._auth) : super(methods: {Method.get}, path: '/relay/:matchId');

  final AuthenticationHandler _auth;
  final _rooms = <String, _Room>{};

  @override
  FutureOr<Result> handleCall(Session session, Request request) {
    final matchId = request.pathParameters.raw[#matchId];
    if (matchId == null) return Response.notFound();
    // Auth is the first frame, not the URL, so tokens never reach access logs.
    // The Origin check is skipped because browsers do not apply CORS to sockets
    // and no cookie is used here.
    return WebSocketUpgrade(allowAnyOrigin: true, (ws) async {
      ws.pingInterval = const Duration(seconds: 20);
      final events = StreamIterator(ws.events);
      String? role;
      try {
        final first = await _firstText(events).timeout(_authWindow);
        role = await _admit(session, matchId, first, ws);
        if (role == null) {
          await ws.tryClose(4003, 'not allowed');
          return;
        }
        final room = _rooms[matchId]!;
        ws.trySendText(jsonEncode({'relay': 'ok', 'role': role, 'peer': room.peerOf(role) != null}));
        room.peerOf(role)?.trySendText(jsonEncode({'relay': 'peer'}));

        while (await events.moveNext()) {
          final e = events.current;
          if (e is TextDataReceived && e.text.length <= _maxFrame) {
            _rooms[matchId]?.peerOf(role)?.trySendText(e.text);
          }
        }
      } on TimeoutException {
        await ws.tryClose(4008, 'auth timeout');
      } finally {
        await events.cancel();
        if (role != null) _leave(matchId, role, ws);
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

  /// Returns the caller's role in the match, or null if they may not join.
  Future<String?> _admit(Session session, String matchId, String first, RelicWebSocket ws) async {
    try {
      final token = (jsonDecode(first) as Map)['token'] as String?;
      if (token == null) return null;
      final info = await _auth(session, token);
      if (info == null) return null;
      final match = await FriendMatch.db.findById(session, UuidValue.fromString(matchId));
      if (match == null || match.status != 'live') return null;
      final role = match.hostUserId == info.userIdentifier
          ? 'host'
          : match.guestUserId == info.userIdentifier
              ? 'guest'
              : null;
      if (role == null) return null;
      final room = _rooms.putIfAbsent(matchId, _Room.new);
      final old = role == 'host' ? room.host : room.guest;
      if (role == 'host') {
        room.host = ws;
      } else {
        room.guest = ws;
      }
      // A reconnect replaces the stale socket.
      if (old != null && !identical(old, ws)) await old.tryClose(1000, 'replaced');
      return role;
    } catch (_) {
      return null;
    }
  }

  void _leave(String matchId, String role, RelicWebSocket ws) {
    final room = _rooms[matchId];
    if (room == null) return;
    final mine = role == 'host' ? room.host : room.guest;
    if (!identical(mine, ws)) return; // already replaced by a reconnect
    if (role == 'host') {
      room.host = null;
    } else {
      room.guest = null;
    }
    room.peerOf(role)?.trySendText(jsonEncode({'relay': 'peer-left'}));
    if (room.host == null && room.guest == null) _rooms.remove(matchId);
  }
}
