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
import '../social/head_to_head.dart' as _ihsdpue7;

/// A player friend-match record. Draws count as draws, abandoned matches count for nobody.
abstract class RecordView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RecordView._({
    required this.wins,
    required this.draws,
    required this.losses,
    required this.abandoned,
    required this.headToHead,
  });

  factory RecordView({
    required int wins,
    required int draws,
    required int losses,
    required int abandoned,
    required List<_ihsdpue7.HeadToHead> headToHead,
  }) = _RecordViewImpl;

  factory RecordView.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecordView(
      wins: jsonSerialization['wins'] as int,
      draws: jsonSerialization['draws'] as int,
      losses: jsonSerialization['losses'] as int,
      abandoned: jsonSerialization['abandoned'] as int,
      headToHead: _irwjntvu.Protocol().deserialize<List<_ihsdpue7.HeadToHead>>(
        jsonSerialization['headToHead'],
      ),
    );
  }

  int wins;

  int draws;

  int losses;

  int abandoned;

  List<_ihsdpue7.HeadToHead> headToHead;

  /// Returns a shallow copy of this [RecordView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RecordView copyWith({
    int? wins,
    int? draws,
    int? losses,
    int? abandoned,
    List<_ihsdpue7.HeadToHead>? headToHead,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecordView',
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'abandoned': abandoned,
      'headToHead': headToHead.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecordView',
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'abandoned': abandoned,
      'headToHead': headToHead.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _RecordViewImpl extends RecordView {
  _RecordViewImpl({
    required int wins,
    required int draws,
    required int losses,
    required int abandoned,
    required List<_ihsdpue7.HeadToHead> headToHead,
  }) : super._(
         wins: wins,
         draws: draws,
         losses: losses,
         abandoned: abandoned,
         headToHead: headToHead,
       );

  /// Returns a shallow copy of this [RecordView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RecordView copyWith({
    int? wins,
    int? draws,
    int? losses,
    int? abandoned,
    List<_ihsdpue7.HeadToHead>? headToHead,
  }) {
    return RecordView(
      wins: wins ?? this.wins,
      draws: draws ?? this.draws,
      losses: losses ?? this.losses,
      abandoned: abandoned ?? this.abandoned,
      headToHead:
          headToHead ?? this.headToHead.map((e0) => e0.copyWith()).toList(),
    );
  }
}
