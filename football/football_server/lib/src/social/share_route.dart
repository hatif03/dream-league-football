import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'share_endpoint.dart';

String _esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');

final _uuid = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');

/// `/r/<id>`: the page a shared result link opens. It carries Open Graph and Twitter card tags so a chat
/// app shows the score picture as a preview, and a button that takes a person into the game.
class ShareRoute extends Route {
  ShareRoute() : super(methods: {Method.get}, path: '/r/:id');

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    final raw = request.pathParameters.raw[#id];
    UuidValue? id;
    try {
      id = raw != null && _uuid.hasMatch(raw) ? UuidValue.fromString(raw) : null;
    } catch (_) {
      id = null;
    }
    final row = id == null ? null : await SharedResult.db.findById(session, id);
    final image = row == null ? null : await sharedImageUrl(session, row);
    if (row == null || image == null) {
      return Response.notFound(body: Body.fromString('That shared result is not available.', mimeType: MimeType.plainText));
    }
    final title = _esc(row.title);
    final desc = _esc(row.description.isEmpty ? 'Play Dream League Football in your browser.' : row.description);
    final img = _esc(image);
    final html = '''<!doctype html>
<html lang="en"><head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$title</title>
<meta name="description" content="$desc">
<meta property="og:type" content="website">
<meta property="og:site_name" content="Dream League Football">
<meta property="og:title" content="$title">
<meta property="og:description" content="$desc">
<meta property="og:image" content="$img">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="$title">
<meta name="twitter:description" content="$desc">
<meta name="twitter:image" content="$img">
<style>
body{margin:0;min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:20px;padding:16px;background:linear-gradient(135deg,#0b0933,#2a2397);color:#fff;font-family:system-ui,sans-serif;text-align:center}
img{max-width:min(100%,900px);height:auto;border-radius:10px;box-shadow:0 20px 60px rgba(0,0,0,.5)}
a{display:inline-block;padding:14px 32px;background:#28e4ff;color:#0b0933;font-weight:800;text-decoration:none;border-radius:6px;font-size:1.1rem}
p{margin:0;color:#bcb8f0}
</style>
</head><body>
<img src="$img" alt="$title">
<p>$desc</p>
<a href="/">Play Dream League Football</a>
</body></html>''';
    return Response.ok(body: Body.fromString(html, mimeType: MimeType.html));
  }
}
