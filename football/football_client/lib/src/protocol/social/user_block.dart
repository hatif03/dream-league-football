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

/// One player blocking another: no invites, requests or shared rooms either way.
abstract class UserBlock
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UserBlock._({
    this.id,
    required this.userId,
    required this.blockedUserId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserBlock({
    _isc.UuidValue? id,
    required String userId,
    required String blockedUserId,
    DateTime? createdAt,
  }) = _UserBlockImpl;

  factory UserBlock.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserBlock(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      blockedUserId: jsonSerialization['blockedUserId'] as String,
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

  String blockedUserId;

  DateTime createdAt;

  /// Returns a shallow copy of this [UserBlock]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserBlock copyWith({
    _isc.UuidValue? id,
    String? userId,
    String? blockedUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserBlock',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'blockedUserId': blockedUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserBlock',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'blockedUserId': blockedUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserBlockImpl extends UserBlock {
  _UserBlockImpl({
    _isc.UuidValue? id,
    required String userId,
    required String blockedUserId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         blockedUserId: blockedUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UserBlock]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UserBlock copyWith({
    Object? id = _Undefined,
    String? userId,
    String? blockedUserId,
    DateTime? createdAt,
  }) {
    return UserBlock(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      blockedUserId: blockedUserId ?? this.blockedUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
