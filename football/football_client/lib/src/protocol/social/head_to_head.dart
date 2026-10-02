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

/// Results against one opponent.
abstract class HeadToHead
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HeadToHead._({
    required this.opponentName,
    this.opponentUserId,
    required this.wins,
    required this.draws,
    required this.losses,
  });

  factory HeadToHead({
    required String opponentName,
    String? opponentUserId,
    required int wins,
    required int draws,
    required int losses,
  }) = _HeadToHeadImpl;

  factory HeadToHead.fromJson(Map<String, dynamic> jsonSerialization) {
    return HeadToHead(
      opponentName: jsonSerialization['opponentName'] as String,
      opponentUserId: jsonSerialization['opponentUserId'] as String?,
      wins: jsonSerialization['wins'] as int,
      draws: jsonSerialization['draws'] as int,
      losses: jsonSerialization['losses'] as int,
    );
  }

  String opponentName;

  String? opponentUserId;

  int wins;

  int draws;

  int losses;

  /// Returns a shallow copy of this [HeadToHead]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HeadToHead copyWith({
    String? opponentName,
    String? opponentUserId,
    int? wins,
    int? draws,
    int? losses,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HeadToHead',
      'opponentName': opponentName,
      if (opponentUserId != null) 'opponentUserId': opponentUserId,
      'wins': wins,
      'draws': draws,
      'losses': losses,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HeadToHead',
      'opponentName': opponentName,
      if (opponentUserId != null) 'opponentUserId': opponentUserId,
      'wins': wins,
      'draws': draws,
      'losses': losses,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HeadToHeadImpl extends HeadToHead {
  _HeadToHeadImpl({
    required String opponentName,
    String? opponentUserId,
    required int wins,
    required int draws,
    required int losses,
  }) : super._(
         opponentName: opponentName,
         opponentUserId: opponentUserId,
         wins: wins,
         draws: draws,
         losses: losses,
       );

  /// Returns a shallow copy of this [HeadToHead]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HeadToHead copyWith({
    String? opponentName,
    Object? opponentUserId = _Undefined,
    int? wins,
    int? draws,
    int? losses,
  }) {
    return HeadToHead(
      opponentName: opponentName ?? this.opponentName,
      opponentUserId: opponentUserId is String?
          ? opponentUserId
          : this.opponentUserId,
      wins: wins ?? this.wins,
      draws: draws ?? this.draws,
      losses: losses ?? this.losses,
    );
  }
}
