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
import '../rankings/leader_entry.dart' as _i7m9681z;

abstract class LeaderboardView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LeaderboardView._({
    required this.top,
    this.you,
    required this.total,
  });

  factory LeaderboardView({
    required List<_i7m9681z.LeaderEntry> top,
    _i7m9681z.LeaderEntry? you,
    required int total,
  }) = _LeaderboardViewImpl;

  factory LeaderboardView.fromJson(Map<String, dynamic> jsonSerialization) {
    return LeaderboardView(
      top: _irwjntvu.Protocol().deserialize<List<_i7m9681z.LeaderEntry>>(
        jsonSerialization['top'],
      ),
      you: jsonSerialization['you'] == null
          ? null
          : _irwjntvu.Protocol().deserialize<_i7m9681z.LeaderEntry>(
              jsonSerialization['you'],
            ),
      total: jsonSerialization['total'] as int,
    );
  }

  List<_i7m9681z.LeaderEntry> top;

  /// The caller's own row (with their true rank), or null if they have not played yet.
  _i7m9681z.LeaderEntry? you;

  /// How many players are ranked.
  int total;

  /// Returns a shallow copy of this [LeaderboardView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LeaderboardView copyWith({
    List<_i7m9681z.LeaderEntry>? top,
    _i7m9681z.LeaderEntry? you,
    int? total,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LeaderboardView',
      'top': top.toJson(valueToJson: (v) => v.toJson()),
      if (you != null) 'you': you?.toJson(),
      'total': total,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LeaderboardView',
      'top': top.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (you != null) 'you': you?.toJsonForProtocol(),
      'total': total,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LeaderboardViewImpl extends LeaderboardView {
  _LeaderboardViewImpl({
    required List<_i7m9681z.LeaderEntry> top,
    _i7m9681z.LeaderEntry? you,
    required int total,
  }) : super._(
         top: top,
         you: you,
         total: total,
       );

  /// Returns a shallow copy of this [LeaderboardView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LeaderboardView copyWith({
    List<_i7m9681z.LeaderEntry>? top,
    Object? you = _Undefined,
    int? total,
  }) {
    return LeaderboardView(
      top: top ?? this.top.map((e0) => e0.copyWith()).toList(),
      you: you is _i7m9681z.LeaderEntry? ? you : this.you?.copyWith(),
      total: total ?? this.total,
    );
  }
}
