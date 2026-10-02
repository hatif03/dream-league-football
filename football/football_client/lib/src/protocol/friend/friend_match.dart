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

/// A head-to-head match between two humans. The score is stored only when both
/// players sign the same claim.
abstract class FriendMatch
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FriendMatch._({
    this.id,
    required this.lobbyId,
    this.hostUserId,
    this.guestUserId,
    required this.hostNation,
    required this.guestNation,
    required this.status,
    this.hostClaim,
    this.guestClaim,
    this.hostGoals,
    this.guestGoals,
    this.endReason,
    this.winnerUserId,
    this.leaverUserId,
    this.offer,
    this.answer,
    this.stats,
    this.transport,
    DateTime? startedAt,
    this.firstClaimAt,
    this.endedAt,
  }) : startedAt = startedAt ?? DateTime.now();

  factory FriendMatch({
    _isc.UuidValue? id,
    required _isc.UuidValue lobbyId,
    String? hostUserId,
    String? guestUserId,
    required String hostNation,
    required String guestNation,
    required String status,
    String? hostClaim,
    String? guestClaim,
    int? hostGoals,
    int? guestGoals,
    String? endReason,
    String? winnerUserId,
    String? leaverUserId,
    String? offer,
    String? answer,
    String? stats,
    String? transport,
    DateTime? startedAt,
    DateTime? firstClaimAt,
    DateTime? endedAt,
  }) = _FriendMatchImpl;

  factory FriendMatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return FriendMatch(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      lobbyId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['lobbyId'],
      ),
      hostUserId: jsonSerialization['hostUserId'] as String?,
      guestUserId: jsonSerialization['guestUserId'] as String?,
      hostNation: jsonSerialization['hostNation'] as String,
      guestNation: jsonSerialization['guestNation'] as String,
      status: jsonSerialization['status'] as String,
      hostClaim: jsonSerialization['hostClaim'] as String?,
      guestClaim: jsonSerialization['guestClaim'] as String?,
      hostGoals: jsonSerialization['hostGoals'] as int?,
      guestGoals: jsonSerialization['guestGoals'] as int?,
      endReason: jsonSerialization['endReason'] as String?,
      winnerUserId: jsonSerialization['winnerUserId'] as String?,
      leaverUserId: jsonSerialization['leaverUserId'] as String?,
      offer: jsonSerialization['offer'] as String?,
      answer: jsonSerialization['answer'] as String?,
      stats: jsonSerialization['stats'] as String?,
      transport: jsonSerialization['transport'] as String?,
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      firstClaimAt: jsonSerialization['firstClaimAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstClaimAt'],
            ),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue lobbyId;

  /// The host's browser runs the simulation.
  String? hostUserId;

  String? guestUserId;

  String hostNation;

  String guestNation;

  /// live | finished | abandoned | void
  String status;

  /// Each player's signed claim, as JSON: hostGoals, guestGoals, reason, leaver.
  String? hostClaim;

  String? guestClaim;

  int? hostGoals;

  int? guestGoals;

  /// fulltime | abandoned | mismatch | timeout
  String? endReason;

  /// Empty on a draw, an abandon or a void match.
  String? winnerUserId;

  /// The player who left, for an abandoned match.
  String? leaverUserId;

  /// WebRTC handshake, cleared once the channel opens.
  String? offer;

  String? answer;

  /// End-of-match numbers as JSON, reported by the host (counted by their simulation, not signed by the guest).
  String? stats;

  /// direct | relay, reported by the peers once connected.
  String? transport;

  DateTime startedAt;

  DateTime? firstClaimAt;

  DateTime? endedAt;

  /// Returns a shallow copy of this [FriendMatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FriendMatch copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? lobbyId,
    String? hostUserId,
    String? guestUserId,
    String? hostNation,
    String? guestNation,
    String? status,
    String? hostClaim,
    String? guestClaim,
    int? hostGoals,
    int? guestGoals,
    String? endReason,
    String? winnerUserId,
    String? leaverUserId,
    String? offer,
    String? answer,
    String? stats,
    String? transport,
    DateTime? startedAt,
    DateTime? firstClaimAt,
    DateTime? endedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FriendMatch',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      if (hostUserId != null) 'hostUserId': hostUserId,
      if (guestUserId != null) 'guestUserId': guestUserId,
      'hostNation': hostNation,
      'guestNation': guestNation,
      'status': status,
      if (hostClaim != null) 'hostClaim': hostClaim,
      if (guestClaim != null) 'guestClaim': guestClaim,
      if (hostGoals != null) 'hostGoals': hostGoals,
      if (guestGoals != null) 'guestGoals': guestGoals,
      if (endReason != null) 'endReason': endReason,
      if (winnerUserId != null) 'winnerUserId': winnerUserId,
      if (leaverUserId != null) 'leaverUserId': leaverUserId,
      if (offer != null) 'offer': offer,
      if (answer != null) 'answer': answer,
      if (stats != null) 'stats': stats,
      if (transport != null) 'transport': transport,
      'startedAt': startedAt.toJson(),
      if (firstClaimAt != null) 'firstClaimAt': firstClaimAt?.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FriendMatch',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      if (hostUserId != null) 'hostUserId': hostUserId,
      if (guestUserId != null) 'guestUserId': guestUserId,
      'hostNation': hostNation,
      'guestNation': guestNation,
      'status': status,
      if (hostClaim != null) 'hostClaim': hostClaim,
      if (guestClaim != null) 'guestClaim': guestClaim,
      if (hostGoals != null) 'hostGoals': hostGoals,
      if (guestGoals != null) 'guestGoals': guestGoals,
      if (endReason != null) 'endReason': endReason,
      if (winnerUserId != null) 'winnerUserId': winnerUserId,
      if (leaverUserId != null) 'leaverUserId': leaverUserId,
      if (offer != null) 'offer': offer,
      if (answer != null) 'answer': answer,
      if (stats != null) 'stats': stats,
      if (transport != null) 'transport': transport,
      'startedAt': startedAt.toJson(),
      if (firstClaimAt != null) 'firstClaimAt': firstClaimAt?.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FriendMatchImpl extends FriendMatch {
  _FriendMatchImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue lobbyId,
    String? hostUserId,
    String? guestUserId,
    required String hostNation,
    required String guestNation,
    required String status,
    String? hostClaim,
    String? guestClaim,
    int? hostGoals,
    int? guestGoals,
    String? endReason,
    String? winnerUserId,
    String? leaverUserId,
    String? offer,
    String? answer,
    String? stats,
    String? transport,
    DateTime? startedAt,
    DateTime? firstClaimAt,
    DateTime? endedAt,
  }) : super._(
         id: id,
         lobbyId: lobbyId,
         hostUserId: hostUserId,
         guestUserId: guestUserId,
         hostNation: hostNation,
         guestNation: guestNation,
         status: status,
         hostClaim: hostClaim,
         guestClaim: guestClaim,
         hostGoals: hostGoals,
         guestGoals: guestGoals,
         endReason: endReason,
         winnerUserId: winnerUserId,
         leaverUserId: leaverUserId,
         offer: offer,
         answer: answer,
         stats: stats,
         transport: transport,
         startedAt: startedAt,
         firstClaimAt: firstClaimAt,
         endedAt: endedAt,
       );

  /// Returns a shallow copy of this [FriendMatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FriendMatch copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? lobbyId,
    Object? hostUserId = _Undefined,
    Object? guestUserId = _Undefined,
    String? hostNation,
    String? guestNation,
    String? status,
    Object? hostClaim = _Undefined,
    Object? guestClaim = _Undefined,
    Object? hostGoals = _Undefined,
    Object? guestGoals = _Undefined,
    Object? endReason = _Undefined,
    Object? winnerUserId = _Undefined,
    Object? leaverUserId = _Undefined,
    Object? offer = _Undefined,
    Object? answer = _Undefined,
    Object? stats = _Undefined,
    Object? transport = _Undefined,
    DateTime? startedAt,
    Object? firstClaimAt = _Undefined,
    Object? endedAt = _Undefined,
  }) {
    return FriendMatch(
      id: id is _isc.UuidValue? ? id : this.id,
      lobbyId: lobbyId ?? this.lobbyId,
      hostUserId: hostUserId is String? ? hostUserId : this.hostUserId,
      guestUserId: guestUserId is String? ? guestUserId : this.guestUserId,
      hostNation: hostNation ?? this.hostNation,
      guestNation: guestNation ?? this.guestNation,
      status: status ?? this.status,
      hostClaim: hostClaim is String? ? hostClaim : this.hostClaim,
      guestClaim: guestClaim is String? ? guestClaim : this.guestClaim,
      hostGoals: hostGoals is int? ? hostGoals : this.hostGoals,
      guestGoals: guestGoals is int? ? guestGoals : this.guestGoals,
      endReason: endReason is String? ? endReason : this.endReason,
      winnerUserId: winnerUserId is String? ? winnerUserId : this.winnerUserId,
      leaverUserId: leaverUserId is String? ? leaverUserId : this.leaverUserId,
      offer: offer is String? ? offer : this.offer,
      answer: answer is String? ? answer : this.answer,
      stats: stats is String? ? stats : this.stats,
      transport: transport is String? ? transport : this.transport,
      startedAt: startedAt ?? this.startedAt,
      firstClaimAt: firstClaimAt is DateTime?
          ? firstClaimAt
          : this.firstClaimAt,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
    );
  }
}
