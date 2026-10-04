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

/// One achievement, as the signed-in player stands on it.
abstract class AchievementView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AchievementView._({
    required this.id,
    required this.title,
    required this.description,
    required this.done,
    required this.progress,
    required this.target,
  });

  factory AchievementView({
    required String id,
    required String title,
    required String description,
    required bool done,
    required int progress,
    required int target,
  }) = _AchievementViewImpl;

  factory AchievementView.fromJson(Map<String, dynamic> jsonSerialization) {
    return AchievementView(
      id: jsonSerialization['id'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      done: _isc.BoolJsonExtension.fromJson(jsonSerialization['done']),
      progress: jsonSerialization['progress'] as int,
      target: jsonSerialization['target'] as int,
    );
  }

  String id;

  String title;

  String description;

  bool done;

  /// How far along the player is (never above target).
  int progress;

  int target;

  /// Returns a shallow copy of this [AchievementView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AchievementView copyWith({
    String? id,
    String? title,
    String? description,
    bool? done,
    int? progress,
    int? target,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AchievementView',
      'id': id,
      'title': title,
      'description': description,
      'done': done,
      'progress': progress,
      'target': target,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AchievementView',
      'id': id,
      'title': title,
      'description': description,
      'done': done,
      'progress': progress,
      'target': target,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AchievementViewImpl extends AchievementView {
  _AchievementViewImpl({
    required String id,
    required String title,
    required String description,
    required bool done,
    required int progress,
    required int target,
  }) : super._(
         id: id,
         title: title,
         description: description,
         done: done,
         progress: progress,
         target: target,
       );

  /// Returns a shallow copy of this [AchievementView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AchievementView copyWith({
    String? id,
    String? title,
    String? description,
    bool? done,
    int? progress,
    int? target,
  }) {
    return AchievementView(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      done: done ?? this.done,
      progress: progress ?? this.progress,
      target: target ?? this.target,
    );
  }
}
