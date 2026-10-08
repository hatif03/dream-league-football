import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../auth/current_user.dart';
import '../generated/protocol.dart';
import '../util/rate_limit.dart';

const _maxImage = 2 * 1024 * 1024;
const _storage = 'public';

/// Sharing a result as a link. The picture of the score is kept in Serverpod's cloud storage and the link
/// `/r/<id>` (served by [ShareRoute]) is a small page whose Open Graph tags make chat apps and social
/// networks show the picture as a preview.
class ShareEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Stores a result image (a PNG sent as base64, at most 2 MB) and returns the link id and the image's public URL.
  Future<ShareLink> createResult(Session session, String pngBase64, String title, String description) async {
    final profile = await requireProfile(session);
    rateLimit(profile.userId, 'share.create', max: 12, window: const Duration(hours: 1));
    if (title.trim().isEmpty || title.length > 80) throw GameException(message: 'Bad title.');
    if (description.length > 160) throw GameException(message: 'Description too long.');

    Uint8List bytes;
    try {
      bytes = base64Decode(pngBase64);
    } catch (_) {
      throw GameException(message: 'That is not an image.');
    }
    // A PNG starts with these eight bytes; anything else is refused so only pictures end up public.
    const magic = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    if (bytes.length > _maxImage || bytes.length < 100 || !List.generate(8, (i) => bytes[i] == magic[i]).every((b) => b)) {
      throw GameException(message: 'The image must be a PNG under 2 MB.');
    }

    final row = await SharedResult.db.insertRow(
      session,
      SharedResult(userId: profile.userId, title: title.trim(), description: description.trim(), imagePath: 'pending'),
    );
    final path = 'results/${row.id}.png';
    await session.storage.storeFile(storageId: _storage, path: path, byteData: ByteData.view(bytes.buffer));
    await SharedResult.db.updateRow(session, row.copyWith(imagePath: path));
    final url = await session.storage.publicDownloadUrl(storageId: _storage, path: path);
    return ShareLink(id: row.id.toString(), imageUrl: url.toString());
  }
}

/// The public URL of a stored result image, or null if it cannot be found.
Future<String?> sharedImageUrl(Session session, SharedResult r) async {
  if (!await session.storage.fileExists(storageId: _storage, path: r.imagePath)) return null;
  return (await session.storage.publicDownloadUrl(storageId: _storage, path: r.imagePath)).toString();
}
