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

/// A report about a player, with the match it happened in.
abstract class PlayerReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlayerReport._({
    this.id,
    required this.reporterId,
    required this.targetId,
    this.matchId,
    required this.reason,
    DateTime? createdAt,
    this.resolvedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PlayerReport({
    _isc.UuidValue? id,
    required String reporterId,
    required String targetId,
    _isc.UuidValue? matchId,
    required String reason,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) = _PlayerReportImpl;

  factory PlayerReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlayerReport(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      reporterId: jsonSerialization['reporterId'] as String,
      targetId: jsonSerialization['targetId'] as String,
      matchId: jsonSerialization['matchId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['matchId']),
      reason: jsonSerialization['reason'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
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

  String reporterId;

  String targetId;

  _isc.UuidValue? matchId;

  String reason;

  DateTime createdAt;

  DateTime? resolvedAt;

  /// Returns a shallow copy of this [PlayerReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlayerReport copyWith({
    _isc.UuidValue? id,
    String? reporterId,
    String? targetId,
    _isc.UuidValue? matchId,
    String? reason,
    DateTime? createdAt,
    DateTime? resolvedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlayerReport',
      if (id != null) 'id': id?.toJson(),
      'reporterId': reporterId,
      'targetId': targetId,
      if (matchId != null) 'matchId': matchId?.toJson(),
      'reason': reason,
      'createdAt': createdAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlayerReport',
      if (id != null) 'id': id?.toJson(),
      'reporterId': reporterId,
      'targetId': targetId,
      if (matchId != null) 'matchId': matchId?.toJson(),
      'reason': reason,
      'createdAt': createdAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlayerReportImpl extends PlayerReport {
  _PlayerReportImpl({
    _isc.UuidValue? id,
    required String reporterId,
    required String targetId,
    _isc.UuidValue? matchId,
    required String reason,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) : super._(
         id: id,
         reporterId: reporterId,
         targetId: targetId,
         matchId: matchId,
         reason: reason,
         createdAt: createdAt,
         resolvedAt: resolvedAt,
       );

  /// Returns a shallow copy of this [PlayerReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlayerReport copyWith({
    Object? id = _Undefined,
    String? reporterId,
    String? targetId,
    Object? matchId = _Undefined,
    String? reason,
    DateTime? createdAt,
    Object? resolvedAt = _Undefined,
  }) {
    return PlayerReport(
      id: id is _isc.UuidValue? ? id : this.id,
      reporterId: reporterId ?? this.reporterId,
      targetId: targetId ?? this.targetId,
      matchId: matchId is _isc.UuidValue? ? matchId : this.matchId,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
    );
  }
}
