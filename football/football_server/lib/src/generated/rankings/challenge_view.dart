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
import 'package:serverpod/serverpod.dart' as _is;

/// Today's daily challenge and how far the player is.
abstract class ChallengeView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ChallengeView._({
    required this.day,
    required this.kind,
    required this.title,
    required this.description,
    required this.target,
    required this.progress,
    required this.done,
    required this.streak,
  });

  factory ChallengeView({
    required String day,
    required String kind,
    required String title,
    required String description,
    required int target,
    required int progress,
    required bool done,
    required int streak,
  }) = _ChallengeViewImpl;

  factory ChallengeView.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChallengeView(
      day: jsonSerialization['day'] as String,
      kind: jsonSerialization['kind'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      target: jsonSerialization['target'] as int,
      progress: jsonSerialization['progress'] as int,
      done: _is.BoolJsonExtension.fromJson(jsonSerialization['done']),
      streak: jsonSerialization['streak'] as int,
    );
  }

  /// The UTC day, YYYY-MM-DD.
  String day;

  String kind;

  String title;

  String description;

  int target;

  int progress;

  bool done;

  /// Days in a row, up to yesterday (plus today if done), on which the daily challenge was completed.
  int streak;

  /// Returns a shallow copy of this [ChallengeView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ChallengeView copyWith({
    String? day,
    String? kind,
    String? title,
    String? description,
    int? target,
    int? progress,
    bool? done,
    int? streak,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChallengeView',
      'day': day,
      'kind': kind,
      'title': title,
      'description': description,
      'target': target,
      'progress': progress,
      'done': done,
      'streak': streak,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChallengeView',
      'day': day,
      'kind': kind,
      'title': title,
      'description': description,
      'target': target,
      'progress': progress,
      'done': done,
      'streak': streak,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ChallengeViewImpl extends ChallengeView {
  _ChallengeViewImpl({
    required String day,
    required String kind,
    required String title,
    required String description,
    required int target,
    required int progress,
    required bool done,
    required int streak,
  }) : super._(
         day: day,
         kind: kind,
         title: title,
         description: description,
         target: target,
         progress: progress,
         done: done,
         streak: streak,
       );

  /// Returns a shallow copy of this [ChallengeView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChallengeView copyWith({
    String? day,
    String? kind,
    String? title,
    String? description,
    int? target,
    int? progress,
    bool? done,
    int? streak,
  }) {
    return ChallengeView(
      day: day ?? this.day,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      description: description ?? this.description,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      done: done ?? this.done,
      streak: streak ?? this.streak,
    );
  }
}
