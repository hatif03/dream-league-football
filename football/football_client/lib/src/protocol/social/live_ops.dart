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

/// Single row of switches the operators can flip without a deploy.
abstract class LiveOps
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LiveOps._({
    this.id,
    required this.maintenance,
    this.message,
    required this.updatedAt,
  });

  factory LiveOps({
    _isc.UuidValue? id,
    required bool maintenance,
    String? message,
    required DateTime updatedAt,
  }) = _LiveOpsImpl;

  factory LiveOps.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveOps(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      maintenance: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['maintenance'],
      ),
      message: jsonSerialization['message'] as String?,
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  /// While true no new rooms open; players can still sign in and play on.
  bool maintenance;

  String? message;

  DateTime updatedAt;

  /// Returns a shallow copy of this [LiveOps]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LiveOps copyWith({
    _isc.UuidValue? id,
    bool? maintenance,
    String? message,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveOps',
      if (id != null) 'id': id?.toJson(),
      'maintenance': maintenance,
      if (message != null) 'message': message,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LiveOps',
      if (id != null) 'id': id?.toJson(),
      'maintenance': maintenance,
      if (message != null) 'message': message,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LiveOpsImpl extends LiveOps {
  _LiveOpsImpl({
    _isc.UuidValue? id,
    required bool maintenance,
    String? message,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         maintenance: maintenance,
         message: message,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LiveOps]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LiveOps copyWith({
    Object? id = _Undefined,
    bool? maintenance,
    Object? message = _Undefined,
    DateTime? updatedAt,
  }) {
    return LiveOps(
      id: id is _isc.UuidValue? ? id : this.id,
      maintenance: maintenance ?? this.maintenance,
      message: message is String? ? message : this.message,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
