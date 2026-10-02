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

/// A friend invited into a room. It lives as long as the room is open.
abstract class LobbyInvite
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LobbyInvite._({
    this.id,
    required this.lobbyId,
    required this.fromUserId,
    required this.toUserId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LobbyInvite({
    _isc.UuidValue? id,
    required _isc.UuidValue lobbyId,
    required String fromUserId,
    required String toUserId,
    DateTime? createdAt,
  }) = _LobbyInviteImpl;

  factory LobbyInvite.fromJson(Map<String, dynamic> jsonSerialization) {
    return LobbyInvite(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      lobbyId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['lobbyId'],
      ),
      fromUserId: jsonSerialization['fromUserId'] as String,
      toUserId: jsonSerialization['toUserId'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue lobbyId;

  String fromUserId;

  String toUserId;

  DateTime createdAt;

  /// Returns a shallow copy of this [LobbyInvite]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LobbyInvite copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? lobbyId,
    String? fromUserId,
    String? toUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LobbyInvite',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LobbyInvite',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LobbyInviteImpl extends LobbyInvite {
  _LobbyInviteImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue lobbyId,
    required String fromUserId,
    required String toUserId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         lobbyId: lobbyId,
         fromUserId: fromUserId,
         toUserId: toUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LobbyInvite]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LobbyInvite copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? lobbyId,
    String? fromUserId,
    String? toUserId,
    DateTime? createdAt,
  }) {
    return LobbyInvite(
      id: id is _isc.UuidValue? ? id : this.id,
      lobbyId: lobbyId ?? this.lobbyId,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
