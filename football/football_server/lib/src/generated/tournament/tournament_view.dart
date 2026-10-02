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
import 'package:football_server/src/generated/protocol.dart' as _irwjntvu;
import 'package:serverpod/serverpod.dart' as _is;
import '../tournament/standing_row.dart' as _i7w4w0a3;
import '../tournament/tournament.dart' as _imbpgppz;
import '../tournament/tournament_fixture.dart' as _iucbalk4;

/// Everything the client needs to draw a run.
abstract class TournamentView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TournamentView._({
    required this.tournament,
    required this.fixtures,
    required this.standings,
    this.nextFixtureId,
    required this.matchday,
  });

  factory TournamentView({
    required _imbpgppz.Tournament tournament,
    required List<_iucbalk4.TournamentFixture> fixtures,
    required List<_i7w4w0a3.StandingRow> standings,
    _is.UuidValue? nextFixtureId,
    required int matchday,
  }) = _TournamentViewImpl;

  factory TournamentView.fromJson(Map<String, dynamic> jsonSerialization) {
    return TournamentView(
      tournament: _irwjntvu.Protocol().deserialize<_imbpgppz.Tournament>(
        jsonSerialization['tournament'],
      ),
      fixtures: _irwjntvu.Protocol()
          .deserialize<List<_iucbalk4.TournamentFixture>>(
            jsonSerialization['fixtures'],
          ),
      standings: _irwjntvu.Protocol().deserialize<List<_i7w4w0a3.StandingRow>>(
        jsonSerialization['standings'],
      ),
      nextFixtureId: jsonSerialization['nextFixtureId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['nextFixtureId'],
            ),
      matchday: jsonSerialization['matchday'] as int,
    );
  }

  _imbpgppz.Tournament tournament;

  List<_iucbalk4.TournamentFixture> fixtures;

  List<_i7w4w0a3.StandingRow> standings;

  /// Fixture the user has to play next, null when the group stage is over.
  _is.UuidValue? nextFixtureId;

  /// Matchday of that fixture (1-3), or 0.
  int matchday;

  /// Returns a shallow copy of this [TournamentView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TournamentView copyWith({
    _imbpgppz.Tournament? tournament,
    List<_iucbalk4.TournamentFixture>? fixtures,
    List<_i7w4w0a3.StandingRow>? standings,
    _is.UuidValue? nextFixtureId,
    int? matchday,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TournamentView',
      'tournament': tournament.toJson(),
      'fixtures': fixtures.toJson(valueToJson: (v) => v.toJson()),
      'standings': standings.toJson(valueToJson: (v) => v.toJson()),
      if (nextFixtureId != null) 'nextFixtureId': nextFixtureId?.toJson(),
      'matchday': matchday,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TournamentView',
      'tournament': tournament.toJsonForProtocol(),
      'fixtures': fixtures.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'standings': standings.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nextFixtureId != null) 'nextFixtureId': nextFixtureId?.toJson(),
      'matchday': matchday,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TournamentViewImpl extends TournamentView {
  _TournamentViewImpl({
    required _imbpgppz.Tournament tournament,
    required List<_iucbalk4.TournamentFixture> fixtures,
    required List<_i7w4w0a3.StandingRow> standings,
    _is.UuidValue? nextFixtureId,
    required int matchday,
  }) : super._(
         tournament: tournament,
         fixtures: fixtures,
         standings: standings,
         nextFixtureId: nextFixtureId,
         matchday: matchday,
       );

  /// Returns a shallow copy of this [TournamentView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TournamentView copyWith({
    _imbpgppz.Tournament? tournament,
    List<_iucbalk4.TournamentFixture>? fixtures,
    List<_i7w4w0a3.StandingRow>? standings,
    Object? nextFixtureId = _Undefined,
    int? matchday,
  }) {
    return TournamentView(
      tournament: tournament ?? this.tournament.copyWith(),
      fixtures: fixtures ?? this.fixtures.map((e0) => e0.copyWith()).toList(),
      standings:
          standings ?? this.standings.map((e0) => e0.copyWith()).toList(),
      nextFixtureId: nextFixtureId is _is.UuidValue?
          ? nextFixtureId
          : this.nextFixtureId,
      matchday: matchday ?? this.matchday,
    );
  }
}
