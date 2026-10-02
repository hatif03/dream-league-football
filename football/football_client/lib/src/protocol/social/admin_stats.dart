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

/// Counts for the operator.
abstract class AdminStats
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminStats._({
    required this.openLobbies,
    required this.liveMatches,
    required this.profiles,
    required this.openReports,
  });

  factory AdminStats({
    required int openLobbies,
    required int liveMatches,
    required int profiles,
    required int openReports,
  }) = _AdminStatsImpl;

  factory AdminStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminStats(
      openLobbies: jsonSerialization['openLobbies'] as int,
      liveMatches: jsonSerialization['liveMatches'] as int,
      profiles: jsonSerialization['profiles'] as int,
      openReports: jsonSerialization['openReports'] as int,
    );
  }

  int openLobbies;

  int liveMatches;

  int profiles;

  int openReports;

  /// Returns a shallow copy of this [AdminStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminStats copyWith({
    int? openLobbies,
    int? liveMatches,
    int? profiles,
    int? openReports,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminStats',
      'openLobbies': openLobbies,
      'liveMatches': liveMatches,
      'profiles': profiles,
      'openReports': openReports,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminStats',
      'openLobbies': openLobbies,
      'liveMatches': liveMatches,
      'profiles': profiles,
      'openReports': openReports,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AdminStatsImpl extends AdminStats {
  _AdminStatsImpl({
    required int openLobbies,
    required int liveMatches,
    required int profiles,
    required int openReports,
  }) : super._(
         openLobbies: openLobbies,
         liveMatches: liveMatches,
         profiles: profiles,
         openReports: openReports,
       );

  /// Returns a shallow copy of this [AdminStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminStats copyWith({
    int? openLobbies,
    int? liveMatches,
    int? profiles,
    int? openReports,
  }) {
    return AdminStats(
      openLobbies: openLobbies ?? this.openLobbies,
      liveMatches: liveMatches ?? this.liveMatches,
      profiles: profiles ?? this.profiles,
      openReports: openReports ?? this.openReports,
    );
  }
}
