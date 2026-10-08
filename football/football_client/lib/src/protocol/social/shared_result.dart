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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// A result a player chose to share: the picture lives in cloud storage, this row backs the /r/<id> link.
abstract class SharedResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SharedResult._({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SharedResult({
    _isc.UuidValue? id,
    required String userId,
    required String title,
    required String description,
    required String imagePath,
    DateTime? createdAt,
  }) = _SharedResultImpl;

  factory SharedResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedResult(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      imagePath: jsonSerialization['imagePath'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String userId;

  String title;

  String description;

  /// Path inside the public cloud storage.
  String imagePath;

  DateTime createdAt;

  /// Returns a shallow copy of this [SharedResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SharedResult copyWith({
    _isc.UuidValue? id,
    String? userId,
    String? title,
    String? description,
    String? imagePath,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedResult',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedResult',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedResultImpl extends SharedResult {
  _SharedResultImpl({
    _isc.UuidValue? id,
    required String userId,
    required String title,
    required String description,
    required String imagePath,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         description: description,
         imagePath: imagePath,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SharedResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SharedResult copyWith({
    Object? id = _Undefined,
    String? userId,
    String? title,
    String? description,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return SharedResult(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
