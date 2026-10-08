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

/// Payload of the scheduled call that settles a kick whose time ran out.
abstract class KickDue
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  KickDue._({
    required this.matchId,
    required this.seq,
  });

  factory KickDue({
    required _isc.UuidValue matchId,
    required int seq,
  }) = _KickDueImpl;

  factory KickDue.fromJson(Map<String, dynamic> jsonSerialization) {
    return KickDue(
      matchId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['matchId'],
      ),
      seq: jsonSerialization['seq'] as int,
    );
  }

  _isc.UuidValue matchId;

  int seq;

  /// Returns a shallow copy of this [KickDue]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  KickDue copyWith({
    _isc.UuidValue? matchId,
    int? seq,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'KickDue',
      'matchId': matchId.toJson(),
      'seq': seq,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'KickDue',
      'matchId': matchId.toJson(),
      'seq': seq,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _KickDueImpl extends KickDue {
  _KickDueImpl({
    required _isc.UuidValue matchId,
    required int seq,
  }) : super._(
         matchId: matchId,
         seq: seq,
       );

  /// Returns a shallow copy of this [KickDue]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  KickDue copyWith({
    _isc.UuidValue? matchId,
    int? seq,
  }) {
    return KickDue(
      matchId: matchId ?? this.matchId,
      seq: seq ?? this.seq,
    );
  }
}
