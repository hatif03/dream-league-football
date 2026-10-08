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
import 'package:serverpod/serverpod.dart' as _is;

/// A kick as a player may see it. Until it is resolved only who shoots is shown.
abstract class KickView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  KickView._({
    required this.seq,
    required this.shooterIsHost,
    this.shooterZone,
    this.keeperZone,
    this.outcome,
  });

  factory KickView({
    required int seq,
    required bool shooterIsHost,
    int? shooterZone,
    int? keeperZone,
    String? outcome,
  }) = _KickViewImpl;

  factory KickView.fromJson(Map<String, dynamic> jsonSerialization) {
    return KickView(
      seq: jsonSerialization['seq'] as int,
      shooterIsHost: _is.BoolJsonExtension.fromJson(
        jsonSerialization['shooterIsHost'],
      ),
      shooterZone: jsonSerialization['shooterZone'] as int?,
      keeperZone: jsonSerialization['keeperZone'] as int?,
      outcome: jsonSerialization['outcome'] as String?,
    );
  }

  int seq;

  bool shooterIsHost;

  int? shooterZone;

  int? keeperZone;

  String? outcome;

  /// Returns a shallow copy of this [KickView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  KickView copyWith({
    int? seq,
    bool? shooterIsHost,
    int? shooterZone,
    int? keeperZone,
    String? outcome,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'KickView',
      'seq': seq,
      'shooterIsHost': shooterIsHost,
      if (shooterZone != null) 'shooterZone': shooterZone,
      if (keeperZone != null) 'keeperZone': keeperZone,
      if (outcome != null) 'outcome': outcome,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'KickView',
      'seq': seq,
      'shooterIsHost': shooterIsHost,
      if (shooterZone != null) 'shooterZone': shooterZone,
      if (keeperZone != null) 'keeperZone': keeperZone,
      if (outcome != null) 'outcome': outcome,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _KickViewImpl extends KickView {
  _KickViewImpl({
    required int seq,
    required bool shooterIsHost,
    int? shooterZone,
    int? keeperZone,
    String? outcome,
  }) : super._(
         seq: seq,
         shooterIsHost: shooterIsHost,
         shooterZone: shooterZone,
         keeperZone: keeperZone,
         outcome: outcome,
       );

  /// Returns a shallow copy of this [KickView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  KickView copyWith({
    int? seq,
    bool? shooterIsHost,
    Object? shooterZone = _Undefined,
    Object? keeperZone = _Undefined,
    Object? outcome = _Undefined,
  }) {
    return KickView(
      seq: seq ?? this.seq,
      shooterIsHost: shooterIsHost ?? this.shooterIsHost,
      shooterZone: shooterZone is int? ? shooterZone : this.shooterZone,
      keeperZone: keeperZone is int? ? keeperZone : this.keeperZone,
      outcome: outcome is String? ? outcome : this.outcome,
    );
  }
}
