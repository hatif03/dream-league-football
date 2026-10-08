/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class ShareLink
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ShareLink._({
    required this.id,
    required this.imageUrl,
  });

  factory ShareLink({
    required String id,
    required String imageUrl,
  }) = _ShareLinkImpl;

  factory ShareLink.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShareLink(
      id: jsonSerialization['id'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String,
    );
  }

  String id;

  String imageUrl;

  /// Returns a shallow copy of this [ShareLink]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ShareLink copyWith({
    String? id,
    String? imageUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShareLink',
      'id': id,
      'imageUrl': imageUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShareLink',
      'id': id,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ShareLinkImpl extends ShareLink {
  _ShareLinkImpl({
    required String id,
    required String imageUrl,
  }) : super._(
         id: id,
         imageUrl: imageUrl,
       );

  /// Returns a shallow copy of this [ShareLink]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ShareLink copyWith({
    String? id,
    String? imageUrl,
  }) {
    return ShareLink(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
