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

/// One fixture inside a run. Scores stay null until it has been played or simulated.
abstract class TournamentFixture
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TournamentFixture._({
    this.id,
    required this.tournamentId,
    required this.round,
    required this.groupName,
    required this.matchday,
    required this.kickoffUtc,
    required this.homeNation,
    required this.awayNation,
    required this.venue,
    this.matchNo,
    this.homeScore,
    this.awayScore,
    this.homePens,
    this.awayPens,
    this.decidedBy,
    required this.playedByUser,
    this.nonce,
  });

  factory TournamentFixture({
    _isc.UuidValue? id,
    required _isc.UuidValue tournamentId,
    required String round,
    required String groupName,
    required int matchday,
    required DateTime kickoffUtc,
    required String homeNation,
    required String awayNation,
    required String venue,
    int? matchNo,
    int? homeScore,
    int? awayScore,
    int? homePens,
    int? awayPens,
    String? decidedBy,
    required bool playedByUser,
    String? nonce,
  }) = _TournamentFixtureImpl;

  factory TournamentFixture.fromJson(Map<String, dynamic> jsonSerialization) {
    return TournamentFixture(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tournamentId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['tournamentId'],
      ),
      round: jsonSerialization['round'] as String,
      groupName: jsonSerialization['groupName'] as String,
      matchday: jsonSerialization['matchday'] as int,
      kickoffUtc: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['kickoffUtc'],
      ),
      homeNation: jsonSerialization['homeNation'] as String,
      awayNation: jsonSerialization['awayNation'] as String,
      venue: jsonSerialization['venue'] as String,
      matchNo: jsonSerialization['matchNo'] as int?,
      homeScore: jsonSerialization['homeScore'] as int?,
      awayScore: jsonSerialization['awayScore'] as int?,
      homePens: jsonSerialization['homePens'] as int?,
      awayPens: jsonSerialization['awayPens'] as int?,
      decidedBy: jsonSerialization['decidedBy'] as String?,
      playedByUser: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['playedByUser'],
      ),
      nonce: jsonSerialization['nonce'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue tournamentId;

  /// group | r32 | r16 | qf | sf | final
  String round;

  String groupName;

  int matchday;

  DateTime kickoffUtc;

  String homeNation;

  String awayNation;

  String venue;

  /// FIFA match number (73-104) for knockout games, null in the group stage.
  int? matchNo;

  int? homeScore;

  int? awayScore;

  /// Shootout goals when a knockout game was level after extra time.
  int? homePens;

  int? awayPens;

  /// 90 | et | pens
  String? decidedBy;

  /// true when the user played it, false when the server simulated it.
  bool playedByUser;

  /// Client nonce of the saved result; makes the post idempotent.
  String? nonce;

  /// Returns a shallow copy of this [TournamentFixture]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TournamentFixture copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tournamentId,
    String? round,
    String? groupName,
    int? matchday,
    DateTime? kickoffUtc,
    String? homeNation,
    String? awayNation,
    String? venue,
    int? matchNo,
    int? homeScore,
    int? awayScore,
    int? homePens,
    int? awayPens,
    String? decidedBy,
    bool? playedByUser,
    String? nonce,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TournamentFixture',
      if (id != null) 'id': id?.toJson(),
      'tournamentId': tournamentId.toJson(),
      'round': round,
      'groupName': groupName,
      'matchday': matchday,
      'kickoffUtc': kickoffUtc.toJson(),
      'homeNation': homeNation,
      'awayNation': awayNation,
      'venue': venue,
      if (matchNo != null) 'matchNo': matchNo,
      if (homeScore != null) 'homeScore': homeScore,
      if (awayScore != null) 'awayScore': awayScore,
      if (homePens != null) 'homePens': homePens,
      if (awayPens != null) 'awayPens': awayPens,
      if (decidedBy != null) 'decidedBy': decidedBy,
      'playedByUser': playedByUser,
      if (nonce != null) 'nonce': nonce,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TournamentFixture',
      if (id != null) 'id': id?.toJson(),
      'tournamentId': tournamentId.toJson(),
      'round': round,
      'groupName': groupName,
      'matchday': matchday,
      'kickoffUtc': kickoffUtc.toJson(),
      'homeNation': homeNation,
      'awayNation': awayNation,
      'venue': venue,
      if (matchNo != null) 'matchNo': matchNo,
      if (homeScore != null) 'homeScore': homeScore,
      if (awayScore != null) 'awayScore': awayScore,
      if (homePens != null) 'homePens': homePens,
      if (awayPens != null) 'awayPens': awayPens,
      if (decidedBy != null) 'decidedBy': decidedBy,
      'playedByUser': playedByUser,
      if (nonce != null) 'nonce': nonce,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TournamentFixtureImpl extends TournamentFixture {
  _TournamentFixtureImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue tournamentId,
    required String round,
    required String groupName,
    required int matchday,
    required DateTime kickoffUtc,
    required String homeNation,
    required String awayNation,
    required String venue,
    int? matchNo,
    int? homeScore,
    int? awayScore,
    int? homePens,
    int? awayPens,
    String? decidedBy,
    required bool playedByUser,
    String? nonce,
  }) : super._(
         id: id,
         tournamentId: tournamentId,
         round: round,
         groupName: groupName,
         matchday: matchday,
         kickoffUtc: kickoffUtc,
         homeNation: homeNation,
         awayNation: awayNation,
         venue: venue,
         matchNo: matchNo,
         homeScore: homeScore,
         awayScore: awayScore,
         homePens: homePens,
         awayPens: awayPens,
         decidedBy: decidedBy,
         playedByUser: playedByUser,
         nonce: nonce,
       );

  /// Returns a shallow copy of this [TournamentFixture]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TournamentFixture copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? tournamentId,
    String? round,
    String? groupName,
    int? matchday,
    DateTime? kickoffUtc,
    String? homeNation,
    String? awayNation,
    String? venue,
    Object? matchNo = _Undefined,
    Object? homeScore = _Undefined,
    Object? awayScore = _Undefined,
    Object? homePens = _Undefined,
    Object? awayPens = _Undefined,
    Object? decidedBy = _Undefined,
    bool? playedByUser,
    Object? nonce = _Undefined,
  }) {
    return TournamentFixture(
      id: id is _isc.UuidValue? ? id : this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      round: round ?? this.round,
      groupName: groupName ?? this.groupName,
      matchday: matchday ?? this.matchday,
      kickoffUtc: kickoffUtc ?? this.kickoffUtc,
      homeNation: homeNation ?? this.homeNation,
      awayNation: awayNation ?? this.awayNation,
      venue: venue ?? this.venue,
      matchNo: matchNo is int? ? matchNo : this.matchNo,
      homeScore: homeScore is int? ? homeScore : this.homeScore,
      awayScore: awayScore is int? ? awayScore : this.awayScore,
      homePens: homePens is int? ? homePens : this.homePens,
      awayPens: awayPens is int? ? awayPens : this.awayPens,
      decidedBy: decidedBy is String? ? decidedBy : this.decidedBy,
      playedByUser: playedByUser ?? this.playedByUser,
      nonce: nonce is String? ? nonce : this.nonce,
    );
  }
}
