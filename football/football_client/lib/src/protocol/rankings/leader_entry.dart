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

/// One row of the leaderboard.
abstract class LeaderEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LeaderEntry._({
    required this.rank,
    required this.userId,
    required this.name,
    this.avatar,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.titles,
    required this.points,
    required this.rating,
  });

  factory LeaderEntry({
    required int rank,
    required String userId,
    required String name,
    int? avatar,
    required int played,
    required int wins,
    required int draws,
    required int losses,
    required int titles,
    required int points,
    required int rating,
  }) = _LeaderEntryImpl;

  factory LeaderEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return LeaderEntry(
      rank: jsonSerialization['rank'] as int,
      userId: jsonSerialization['userId'] as String,
      name: jsonSerialization['name'] as String,
      avatar: jsonSerialization['avatar'] as int?,
      played: jsonSerialization['played'] as int,
      wins: jsonSerialization['wins'] as int,
      draws: jsonSerialization['draws'] as int,
      losses: jsonSerialization['losses'] as int,
      titles: jsonSerialization['titles'] as int,
      points: jsonSerialization['points'] as int,
      rating: jsonSerialization['rating'] as int,
    );
  }

  int rank;

  String userId;

  String name;

  int? avatar;

  int played;

  int wins;

  int draws;

  int losses;

  /// Solo World Cups won.
  int titles;

  int points;

  int rating;

  /// Returns a shallow copy of this [LeaderEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LeaderEntry copyWith({
    int? rank,
    String? userId,
    String? name,
    int? avatar,
    int? played,
    int? wins,
    int? draws,
    int? losses,
    int? titles,
    int? points,
    int? rating,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LeaderEntry',
      'rank': rank,
      'userId': userId,
      'name': name,
      if (avatar != null) 'avatar': avatar,
      'played': played,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'titles': titles,
      'points': points,
      'rating': rating,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LeaderEntry',
      'rank': rank,
      'userId': userId,
      'name': name,
      if (avatar != null) 'avatar': avatar,
      'played': played,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'titles': titles,
      'points': points,
      'rating': rating,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LeaderEntryImpl extends LeaderEntry {
  _LeaderEntryImpl({
    required int rank,
    required String userId,
    required String name,
    int? avatar,
    required int played,
    required int wins,
    required int draws,
    required int losses,
    required int titles,
    required int points,
    required int rating,
  }) : super._(
         rank: rank,
         userId: userId,
         name: name,
         avatar: avatar,
         played: played,
         wins: wins,
         draws: draws,
         losses: losses,
         titles: titles,
         points: points,
         rating: rating,
       );

  /// Returns a shallow copy of this [LeaderEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LeaderEntry copyWith({
    int? rank,
    String? userId,
    String? name,
    Object? avatar = _Undefined,
    int? played,
    int? wins,
    int? draws,
    int? losses,
    int? titles,
    int? points,
    int? rating,
  }) {
    return LeaderEntry(
      rank: rank ?? this.rank,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatar: avatar is int? ? avatar : this.avatar,
      played: played ?? this.played,
      wins: wins ?? this.wins,
      draws: draws ?? this.draws,
      losses: losses ?? this.losses,
      titles: titles ?? this.titles,
      points: points ?? this.points,
      rating: rating ?? this.rating,
    );
  }
}
