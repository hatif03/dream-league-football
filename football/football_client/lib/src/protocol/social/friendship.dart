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

/// A friend request or an accepted friendship between two players.
abstract class Friendship
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Friendship._({
    this.id,
    required this.requesterId,
    required this.addresseeId,
    required this.status,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Friendship({
    _isc.UuidValue? id,
    required String requesterId,
    required String addresseeId,
    required String status,
    DateTime? createdAt,
  }) = _FriendshipImpl;

  factory Friendship.fromJson(Map<String, dynamic> jsonSerialization) {
    return Friendship(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      requesterId: jsonSerialization['requesterId'] as String,
      addresseeId: jsonSerialization['addresseeId'] as String,
      status: jsonSerialization['status'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String requesterId;

  String addresseeId;

  /// pending | accepted
  String status;

  DateTime createdAt;

  /// Returns a shallow copy of this [Friendship]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Friendship copyWith({
    _isc.UuidValue? id,
    String? requesterId,
    String? addresseeId,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Friendship',
      if (id != null) 'id': id?.toJson(),
      'requesterId': requesterId,
      'addresseeId': addresseeId,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Friendship',
      if (id != null) 'id': id?.toJson(),
      'requesterId': requesterId,
      'addresseeId': addresseeId,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FriendshipImpl extends Friendship {
  _FriendshipImpl({
    _isc.UuidValue? id,
    required String requesterId,
    required String addresseeId,
    required String status,
    DateTime? createdAt,
  }) : super._(
         id: id,
         requesterId: requesterId,
         addresseeId: addresseeId,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Friendship]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Friendship copyWith({
    Object? id = _Undefined,
    String? requesterId,
    String? addresseeId,
    String? status,
    DateTime? createdAt,
  }) {
    return Friendship(
      id: id is _isc.UuidValue? ? id : this.id,
      requesterId: requesterId ?? this.requesterId,
      addresseeId: addresseeId ?? this.addresseeId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
