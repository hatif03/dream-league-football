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

/// One kick of a penalty duel. The server draws the result when both players have chosen.
abstract class PenaltyKick
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PenaltyKick._({
    this.id,
    required this.matchId,
    required this.seq,
    required this.shooterUserId,
    this.shooterZone,
    this.keeperZone,
    this.outcome,
    required this.deadline,
    this.resolvedAt,
  });

  factory PenaltyKick({
    _isc.UuidValue? id,
    required _isc.UuidValue matchId,
    required int seq,
    required String shooterUserId,
    int? shooterZone,
    int? keeperZone,
    String? outcome,
    required DateTime deadline,
    DateTime? resolvedAt,
  }) = _PenaltyKickImpl;

  factory PenaltyKick.fromJson(Map<String, dynamic> jsonSerialization) {
    return PenaltyKick(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      matchId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['matchId'],
      ),
      seq: jsonSerialization['seq'] as int,
      shooterUserId: jsonSerialization['shooterUserId'] as String,
      shooterZone: jsonSerialization['shooterZone'] as int?,
      keeperZone: jsonSerialization['keeperZone'] as int?,
      outcome: jsonSerialization['outcome'] as String?,
      deadline: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['deadline'],
      ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['resolvedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue matchId;

  /// 0, 2, 4... the host shoots; 1, 3, 5... the guest shoots.
  int seq;

  String shooterUserId;

  /// 0-5: top left, top centre, top right, bottom left, bottom centre, bottom right.
  int? shooterZone;

  int? keeperZone;

  /// goal | saved | miss | post, set when the kick is resolved.
  String? outcome;

  /// Each player has until then to choose; whoever has not is picked for by the server.
  DateTime deadline;

  DateTime? resolvedAt;

  /// Returns a shallow copy of this [PenaltyKick]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PenaltyKick copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? matchId,
    int? seq,
    String? shooterUserId,
    int? shooterZone,
    int? keeperZone,
    String? outcome,
    DateTime? deadline,
    DateTime? resolvedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PenaltyKick',
      if (id != null) 'id': id?.toJson(),
      'matchId': matchId.toJson(),
      'seq': seq,
      'shooterUserId': shooterUserId,
      if (shooterZone != null) 'shooterZone': shooterZone,
      if (keeperZone != null) 'keeperZone': keeperZone,
      if (outcome != null) 'outcome': outcome,
      'deadline': deadline.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PenaltyKick',
      if (id != null) 'id': id?.toJson(),
      'matchId': matchId.toJson(),
      'seq': seq,
      'shooterUserId': shooterUserId,
      if (shooterZone != null) 'shooterZone': shooterZone,
      if (keeperZone != null) 'keeperZone': keeperZone,
      if (outcome != null) 'outcome': outcome,
      'deadline': deadline.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PenaltyKickImpl extends PenaltyKick {
  _PenaltyKickImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue matchId,
    required int seq,
    required String shooterUserId,
    int? shooterZone,
    int? keeperZone,
    String? outcome,
    required DateTime deadline,
    DateTime? resolvedAt,
  }) : super._(
         id: id,
         matchId: matchId,
         seq: seq,
         shooterUserId: shooterUserId,
         shooterZone: shooterZone,
         keeperZone: keeperZone,
         outcome: outcome,
         deadline: deadline,
         resolvedAt: resolvedAt,
       );

  /// Returns a shallow copy of this [PenaltyKick]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PenaltyKick copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? matchId,
    int? seq,
    String? shooterUserId,
    Object? shooterZone = _Undefined,
    Object? keeperZone = _Undefined,
    Object? outcome = _Undefined,
    DateTime? deadline,
    Object? resolvedAt = _Undefined,
  }) {
    return PenaltyKick(
      id: id is _isc.UuidValue? ? id : this.id,
      matchId: matchId ?? this.matchId,
      seq: seq ?? this.seq,
      shooterUserId: shooterUserId ?? this.shooterUserId,
      shooterZone: shooterZone is int? ? shooterZone : this.shooterZone,
      keeperZone: keeperZone is int? ? keeperZone : this.keeperZone,
      outcome: outcome is String? ? outcome : this.outcome,
      deadline: deadline ?? this.deadline,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
    );
  }
}
