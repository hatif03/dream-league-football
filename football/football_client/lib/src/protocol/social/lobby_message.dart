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

/// A line of lobby chat. Stored on the room so a late joiner still sees it.
abstract class LobbyMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LobbyMessage._({
    this.id,
    required this.lobbyId,
    required this.userId,
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LobbyMessage({
    _isc.UuidValue? id,
    required _isc.UuidValue lobbyId,
    required String userId,
    required String text,
    DateTime? createdAt,
  }) = _LobbyMessageImpl;

  factory LobbyMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return LobbyMessage(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      lobbyId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['lobbyId'],
      ),
      userId: jsonSerialization['userId'] as String,
      text: jsonSerialization['text'] as String,
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

  String userId;

  String text;

  DateTime createdAt;

  /// Returns a shallow copy of this [LobbyMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LobbyMessage copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? lobbyId,
    String? userId,
    String? text,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LobbyMessage',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LobbyMessage',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LobbyMessageImpl extends LobbyMessage {
  _LobbyMessageImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue lobbyId,
    required String userId,
    required String text,
    DateTime? createdAt,
  }) : super._(
         id: id,
         lobbyId: lobbyId,
         userId: userId,
         text: text,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LobbyMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LobbyMessage copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? lobbyId,
    String? userId,
    String? text,
    DateTime? createdAt,
  }) {
    return LobbyMessage(
      id: id is _isc.UuidValue? ? id : this.id,
      lobbyId: lobbyId ?? this.lobbyId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
