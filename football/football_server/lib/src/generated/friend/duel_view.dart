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
import '../friend/kick_view.dart' as _iwnydhep;

/// A penalty duel from one player's side.
abstract class DuelView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DuelView._({
    required this.matchId,
    required this.status,
    required this.youAreHost,
    required this.hostName,
    required this.guestName,
    required this.hostGoals,
    required this.guestGoals,
    required this.kicks,
    required this.seq,
    required this.youShoot,
    required this.youSubmitted,
    required this.msLeft,
    this.youWon,
    this.ratingDelta,
  });

  factory DuelView({
    required _is.UuidValue matchId,
    required String status,
    required bool youAreHost,
    required String hostName,
    required String guestName,
    required int hostGoals,
    required int guestGoals,
    required List<_iwnydhep.KickView> kicks,
    required int seq,
    required bool youShoot,
    required bool youSubmitted,
    required int msLeft,
    bool? youWon,
    int? ratingDelta,
  }) = _DuelViewImpl;

  factory DuelView.fromJson(Map<String, dynamic> jsonSerialization) {
    return DuelView(
      matchId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['matchId'],
      ),
      status: jsonSerialization['status'] as String,
      youAreHost: _is.BoolJsonExtension.fromJson(
        jsonSerialization['youAreHost'],
      ),
      hostName: jsonSerialization['hostName'] as String,
      guestName: jsonSerialization['guestName'] as String,
      hostGoals: jsonSerialization['hostGoals'] as int,
      guestGoals: jsonSerialization['guestGoals'] as int,
      kicks: _irwjntvu.Protocol().deserialize<List<_iwnydhep.KickView>>(
        jsonSerialization['kicks'],
      ),
      seq: jsonSerialization['seq'] as int,
      youShoot: _is.BoolJsonExtension.fromJson(jsonSerialization['youShoot']),
      youSubmitted: _is.BoolJsonExtension.fromJson(
        jsonSerialization['youSubmitted'],
      ),
      msLeft: jsonSerialization['msLeft'] as int,
      youWon: jsonSerialization['youWon'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['youWon']),
      ratingDelta: jsonSerialization['ratingDelta'] as int?,
    );
  }

  _is.UuidValue matchId;

  /// live | finished | abandoned | void
  String status;

  bool youAreHost;

  String hostName;

  String guestName;

  int hostGoals;

  int guestGoals;

  List<_iwnydhep.KickView> kicks;

  /// The kick being played now, or -1 once the duel is over.
  int seq;

  bool youShoot;

  /// You already chose for the current kick and are waiting for the other player.
  bool youSubmitted;

  int msLeft;

  /// Set when the duel is over.
  bool? youWon;

  int? ratingDelta;

  /// Returns a shallow copy of this [DuelView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DuelView copyWith({
    _is.UuidValue? matchId,
    String? status,
    bool? youAreHost,
    String? hostName,
    String? guestName,
    int? hostGoals,
    int? guestGoals,
    List<_iwnydhep.KickView>? kicks,
    int? seq,
    bool? youShoot,
    bool? youSubmitted,
    int? msLeft,
    bool? youWon,
    int? ratingDelta,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DuelView',
      'matchId': matchId.toJson(),
      'status': status,
      'youAreHost': youAreHost,
      'hostName': hostName,
      'guestName': guestName,
      'hostGoals': hostGoals,
      'guestGoals': guestGoals,
      'kicks': kicks.toJson(valueToJson: (v) => v.toJson()),
      'seq': seq,
      'youShoot': youShoot,
      'youSubmitted': youSubmitted,
      'msLeft': msLeft,
      if (youWon != null) 'youWon': youWon,
      if (ratingDelta != null) 'ratingDelta': ratingDelta,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DuelView',
      'matchId': matchId.toJson(),
      'status': status,
      'youAreHost': youAreHost,
      'hostName': hostName,
      'guestName': guestName,
      'hostGoals': hostGoals,
      'guestGoals': guestGoals,
      'kicks': kicks.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'seq': seq,
      'youShoot': youShoot,
      'youSubmitted': youSubmitted,
      'msLeft': msLeft,
      if (youWon != null) 'youWon': youWon,
      if (ratingDelta != null) 'ratingDelta': ratingDelta,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelViewImpl extends DuelView {
  _DuelViewImpl({
    required _is.UuidValue matchId,
    required String status,
    required bool youAreHost,
    required String hostName,
    required String guestName,
    required int hostGoals,
    required int guestGoals,
    required List<_iwnydhep.KickView> kicks,
    required int seq,
    required bool youShoot,
    required bool youSubmitted,
    required int msLeft,
    bool? youWon,
    int? ratingDelta,
  }) : super._(
         matchId: matchId,
         status: status,
         youAreHost: youAreHost,
         hostName: hostName,
         guestName: guestName,
         hostGoals: hostGoals,
         guestGoals: guestGoals,
         kicks: kicks,
         seq: seq,
         youShoot: youShoot,
         youSubmitted: youSubmitted,
         msLeft: msLeft,
         youWon: youWon,
         ratingDelta: ratingDelta,
       );

  /// Returns a shallow copy of this [DuelView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DuelView copyWith({
    _is.UuidValue? matchId,
    String? status,
    bool? youAreHost,
    String? hostName,
    String? guestName,
    int? hostGoals,
    int? guestGoals,
    List<_iwnydhep.KickView>? kicks,
    int? seq,
    bool? youShoot,
    bool? youSubmitted,
    int? msLeft,
    Object? youWon = _Undefined,
    Object? ratingDelta = _Undefined,
  }) {
    return DuelView(
      matchId: matchId ?? this.matchId,
      status: status ?? this.status,
      youAreHost: youAreHost ?? this.youAreHost,
      hostName: hostName ?? this.hostName,
      guestName: guestName ?? this.guestName,
      hostGoals: hostGoals ?? this.hostGoals,
      guestGoals: guestGoals ?? this.guestGoals,
      kicks: kicks ?? this.kicks.map((e0) => e0.copyWith()).toList(),
      seq: seq ?? this.seq,
      youShoot: youShoot ?? this.youShoot,
      youSubmitted: youSubmitted ?? this.youSubmitted,
      msLeft: msLeft ?? this.msLeft,
      youWon: youWon is bool? ? youWon : this.youWon,
      ratingDelta: ratingDelta is int? ? ratingDelta : this.ratingDelta,
    );
  }
}
