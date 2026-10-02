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

/// One line of a group table, already ranked.
abstract class StandingRow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StandingRow._({
    required this.groupName,
    required this.nationId,
    required this.position,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
    required this.qualified,
  });

  factory StandingRow({
    required String groupName,
    required String nationId,
    required int position,
    required int played,
    required int won,
    required int drawn,
    required int lost,
    required int goalsFor,
    required int goalsAgainst,
    required int points,
    required bool qualified,
  }) = _StandingRowImpl;

  factory StandingRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return StandingRow(
      groupName: jsonSerialization['groupName'] as String,
      nationId: jsonSerialization['nationId'] as String,
      position: jsonSerialization['position'] as int,
      played: jsonSerialization['played'] as int,
      won: jsonSerialization['won'] as int,
      drawn: jsonSerialization['drawn'] as int,
      lost: jsonSerialization['lost'] as int,
      goalsFor: jsonSerialization['goalsFor'] as int,
      goalsAgainst: jsonSerialization['goalsAgainst'] as int,
      points: jsonSerialization['points'] as int,
      qualified: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['qualified'],
      ),
    );
  }

  String groupName;

  String nationId;

  int position;

  int played;

  int won;

  int drawn;

  int lost;

  int goalsFor;

  int goalsAgainst;

  int points;

  /// Finished in the top two, or among the eight best third-placed teams.
  bool qualified;

  /// Returns a shallow copy of this [StandingRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StandingRow copyWith({
    String? groupName,
    String? nationId,
    int? position,
    int? played,
    int? won,
    int? drawn,
    int? lost,
    int? goalsFor,
    int? goalsAgainst,
    int? points,
    bool? qualified,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StandingRow',
      'groupName': groupName,
      'nationId': nationId,
      'position': position,
      'played': played,
      'won': won,
      'drawn': drawn,
      'lost': lost,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
      'points': points,
      'qualified': qualified,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StandingRow',
      'groupName': groupName,
      'nationId': nationId,
      'position': position,
      'played': played,
      'won': won,
      'drawn': drawn,
      'lost': lost,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
      'points': points,
      'qualified': qualified,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _StandingRowImpl extends StandingRow {
  _StandingRowImpl({
    required String groupName,
    required String nationId,
    required int position,
    required int played,
    required int won,
    required int drawn,
    required int lost,
    required int goalsFor,
    required int goalsAgainst,
    required int points,
    required bool qualified,
  }) : super._(
         groupName: groupName,
         nationId: nationId,
         position: position,
         played: played,
         won: won,
         drawn: drawn,
         lost: lost,
         goalsFor: goalsFor,
         goalsAgainst: goalsAgainst,
         points: points,
         qualified: qualified,
       );

  /// Returns a shallow copy of this [StandingRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StandingRow copyWith({
    String? groupName,
    String? nationId,
    int? position,
    int? played,
    int? won,
    int? drawn,
    int? lost,
    int? goalsFor,
    int? goalsAgainst,
    int? points,
    bool? qualified,
  }) {
    return StandingRow(
      groupName: groupName ?? this.groupName,
      nationId: nationId ?? this.nationId,
      position: position ?? this.position,
      played: played ?? this.played,
      won: won ?? this.won,
      drawn: drawn ?? this.drawn,
      lost: lost ?? this.lost,
      goalsFor: goalsFor ?? this.goalsFor,
      goalsAgainst: goalsAgainst ?? this.goalsAgainst,
      points: points ?? this.points,
      qualified: qualified ?? this.qualified,
    );
  }
}
