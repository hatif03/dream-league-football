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

/// One solo World Cup run for a user.
abstract class Tournament
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Tournament._({
    this.id,
    required this.userId,
    required this.nationId,
    required this.status,
    this.eliminatedIn,
    DateTime? createdAt,
    this.finishedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Tournament({
    _isc.UuidValue? id,
    required String userId,
    required String nationId,
    required String status,
    String? eliminatedIn,
    DateTime? createdAt,
    DateTime? finishedAt,
  }) = _TournamentImpl;

  factory Tournament.fromJson(Map<String, dynamic> jsonSerialization) {
    return Tournament(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      nationId: jsonSerialization['nationId'] as String,
      status: jsonSerialization['status'] as String,
      eliminatedIn: jsonSerialization['eliminatedIn'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['finishedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String userId;

  String nationId;

  /// group | r32 | r16 | qf | sf | final (the round being played) | eliminated | champion
  String status;

  /// Round the run ended in (e.g. "group"), when status is eliminated.
  String? eliminatedIn;

  DateTime createdAt;

  DateTime? finishedAt;

  /// Returns a shallow copy of this [Tournament]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Tournament copyWith({
    _isc.UuidValue? id,
    String? userId,
    String? nationId,
    String? status,
    String? eliminatedIn,
    DateTime? createdAt,
    DateTime? finishedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Tournament',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'nationId': nationId,
      'status': status,
      if (eliminatedIn != null) 'eliminatedIn': eliminatedIn,
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Tournament',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'nationId': nationId,
      'status': status,
      if (eliminatedIn != null) 'eliminatedIn': eliminatedIn,
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TournamentImpl extends Tournament {
  _TournamentImpl({
    _isc.UuidValue? id,
    required String userId,
    required String nationId,
    required String status,
    String? eliminatedIn,
    DateTime? createdAt,
    DateTime? finishedAt,
  }) : super._(
         id: id,
         userId: userId,
         nationId: nationId,
         status: status,
         eliminatedIn: eliminatedIn,
         createdAt: createdAt,
         finishedAt: finishedAt,
       );

  /// Returns a shallow copy of this [Tournament]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Tournament copyWith({
    Object? id = _Undefined,
    String? userId,
    String? nationId,
    String? status,
    Object? eliminatedIn = _Undefined,
    DateTime? createdAt,
    Object? finishedAt = _Undefined,
  }) {
    return Tournament(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      nationId: nationId ?? this.nationId,
      status: status ?? this.status,
      eliminatedIn: eliminatedIn is String? ? eliminatedIn : this.eliminatedIn,
      createdAt: createdAt ?? this.createdAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
    );
  }
}
