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

/// A room where two players pick nations and ready up for a friend match.
abstract class Lobby
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Lobby._({
    this.id,
    required this.code,
    required this.hostUserId,
    this.guestUserId,
    this.hostNation,
    this.guestNation,
    required this.hostReady,
    required this.guestReady,
    String? mode,
    required this.status,
    required this.clientVersion,
    this.matchId,
    this.rematchLobbyId,
    DateTime? createdAt,
    required this.updatedAt,
  }) : mode = mode ?? 'match',
       createdAt = createdAt ?? DateTime.now();

  factory Lobby({
    _isc.UuidValue? id,
    required String code,
    required String hostUserId,
    String? guestUserId,
    String? hostNation,
    String? guestNation,
    required bool hostReady,
    required bool guestReady,
    String? mode,
    required String status,
    required String clientVersion,
    _isc.UuidValue? matchId,
    _isc.UuidValue? rematchLobbyId,
    DateTime? createdAt,
    required DateTime updatedAt,
  }) = _LobbyImpl;

  factory Lobby.fromJson(Map<String, dynamic> jsonSerialization) {
    return Lobby(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      hostUserId: jsonSerialization['hostUserId'] as String,
      guestUserId: jsonSerialization['guestUserId'] as String?,
      hostNation: jsonSerialization['hostNation'] as String?,
      guestNation: jsonSerialization['guestNation'] as String?,
      hostReady: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['hostReady'],
      ),
      guestReady: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['guestReady'],
      ),
      mode: jsonSerialization['mode'] as String?,
      status: jsonSerialization['status'] as String,
      clientVersion: jsonSerialization['clientVersion'] as String,
      matchId: jsonSerialization['matchId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['matchId']),
      rematchLobbyId: jsonSerialization['rematchLobbyId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['rematchLobbyId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  /// Short code a friend types to join.
  String code;

  String hostUserId;

  String? guestUserId;

  String? hostNation;

  String? guestNation;

  bool hostReady;

  bool guestReady;

  /// match (a full 11 v 11) | penalties (a server-refereed penalty duel)
  String mode;

  /// open | live | closed
  String status;

  /// Both players must run the same build; the join is refused otherwise.
  String clientVersion;

  /// Set when both are ready and the match row exists.
  _isc.UuidValue? matchId;

  /// Set when a player starts a rematch from the finished match.
  _isc.UuidValue? rematchLobbyId;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Lobby]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Lobby copyWith({
    _isc.UuidValue? id,
    String? code,
    String? hostUserId,
    String? guestUserId,
    String? hostNation,
    String? guestNation,
    bool? hostReady,
    bool? guestReady,
    String? mode,
    String? status,
    String? clientVersion,
    _isc.UuidValue? matchId,
    _isc.UuidValue? rematchLobbyId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Lobby',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      'hostUserId': hostUserId,
      if (guestUserId != null) 'guestUserId': guestUserId,
      if (hostNation != null) 'hostNation': hostNation,
      if (guestNation != null) 'guestNation': guestNation,
      'hostReady': hostReady,
      'guestReady': guestReady,
      'mode': mode,
      'status': status,
      'clientVersion': clientVersion,
      if (matchId != null) 'matchId': matchId?.toJson(),
      if (rematchLobbyId != null) 'rematchLobbyId': rematchLobbyId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Lobby',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      'hostUserId': hostUserId,
      if (guestUserId != null) 'guestUserId': guestUserId,
      if (hostNation != null) 'hostNation': hostNation,
      if (guestNation != null) 'guestNation': guestNation,
      'hostReady': hostReady,
      'guestReady': guestReady,
      'mode': mode,
      'status': status,
      'clientVersion': clientVersion,
      if (matchId != null) 'matchId': matchId?.toJson(),
      if (rematchLobbyId != null) 'rematchLobbyId': rematchLobbyId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LobbyImpl extends Lobby {
  _LobbyImpl({
    _isc.UuidValue? id,
    required String code,
    required String hostUserId,
    String? guestUserId,
    String? hostNation,
    String? guestNation,
    required bool hostReady,
    required bool guestReady,
    String? mode,
    required String status,
    required String clientVersion,
    _isc.UuidValue? matchId,
    _isc.UuidValue? rematchLobbyId,
    DateTime? createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         hostUserId: hostUserId,
         guestUserId: guestUserId,
         hostNation: hostNation,
         guestNation: guestNation,
         hostReady: hostReady,
         guestReady: guestReady,
         mode: mode,
         status: status,
         clientVersion: clientVersion,
         matchId: matchId,
         rematchLobbyId: rematchLobbyId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Lobby]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Lobby copyWith({
    Object? id = _Undefined,
    String? code,
    String? hostUserId,
    Object? guestUserId = _Undefined,
    Object? hostNation = _Undefined,
    Object? guestNation = _Undefined,
    bool? hostReady,
    bool? guestReady,
    String? mode,
    String? status,
    String? clientVersion,
    Object? matchId = _Undefined,
    Object? rematchLobbyId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Lobby(
      id: id is _isc.UuidValue? ? id : this.id,
      code: code ?? this.code,
      hostUserId: hostUserId ?? this.hostUserId,
      guestUserId: guestUserId is String? ? guestUserId : this.guestUserId,
      hostNation: hostNation is String? ? hostNation : this.hostNation,
      guestNation: guestNation is String? ? guestNation : this.guestNation,
      hostReady: hostReady ?? this.hostReady,
      guestReady: guestReady ?? this.guestReady,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      clientVersion: clientVersion ?? this.clientVersion,
      matchId: matchId is _isc.UuidValue? ? matchId : this.matchId,
      rematchLobbyId: rematchLobbyId is _isc.UuidValue?
          ? rematchLobbyId
          : this.rematchLobbyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
