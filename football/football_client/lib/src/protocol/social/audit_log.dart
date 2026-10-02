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

/// What operators did: bans, voided matches, maintenance toggles.
abstract class AuditLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AuditLog._({
    this.id,
    required this.actorId,
    required this.action,
    this.target,
    this.detail,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AuditLog({
    _isc.UuidValue? id,
    required String actorId,
    required String action,
    String? target,
    String? detail,
    DateTime? createdAt,
  }) = _AuditLogImpl;

  factory AuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditLog(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      actorId: jsonSerialization['actorId'] as String,
      action: jsonSerialization['action'] as String,
      target: jsonSerialization['target'] as String?,
      detail: jsonSerialization['detail'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String actorId;

  String action;

  String? target;

  String? detail;

  DateTime createdAt;

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AuditLog copyWith({
    _isc.UuidValue? id,
    String? actorId,
    String? action,
    String? target,
    String? detail,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLog',
      if (id != null) 'id': id?.toJson(),
      'actorId': actorId,
      'action': action,
      if (target != null) 'target': target,
      if (detail != null) 'detail': detail,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditLog',
      if (id != null) 'id': id?.toJson(),
      'actorId': actorId,
      'action': action,
      if (target != null) 'target': target,
      if (detail != null) 'detail': detail,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditLogImpl extends AuditLog {
  _AuditLogImpl({
    _isc.UuidValue? id,
    required String actorId,
    required String action,
    String? target,
    String? detail,
    DateTime? createdAt,
  }) : super._(
         id: id,
         actorId: actorId,
         action: action,
         target: target,
         detail: detail,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AuditLog copyWith({
    Object? id = _Undefined,
    String? actorId,
    String? action,
    Object? target = _Undefined,
    Object? detail = _Undefined,
    DateTime? createdAt,
  }) {
    return AuditLog(
      id: id is _isc.UuidValue? ? id : this.id,
      actorId: actorId ?? this.actorId,
      action: action ?? this.action,
      target: target is String? ? target : this.target,
      detail: detail is String? ? detail : this.detail,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
