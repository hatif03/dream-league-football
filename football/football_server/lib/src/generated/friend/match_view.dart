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
import '../friend/friend_match.dart' as _i7tx20c1;

/// What a participant sees of a friend match.
abstract class MatchView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MatchView._({
    required this.match,
    required this.hostName,
    required this.guestName,
    required this.youAreHost,
  });

  factory MatchView({
    required _i7tx20c1.FriendMatch match,
    required String hostName,
    required String guestName,
    required bool youAreHost,
  }) = _MatchViewImpl;

  factory MatchView.fromJson(Map<String, dynamic> jsonSerialization) {
    return MatchView(
      match: _irwjntvu.Protocol().deserialize<_i7tx20c1.FriendMatch>(
        jsonSerialization['match'],
      ),
      hostName: jsonSerialization['hostName'] as String,
      guestName: jsonSerialization['guestName'] as String,
      youAreHost: _is.BoolJsonExtension.fromJson(
        jsonSerialization['youAreHost'],
      ),
    );
  }

  _i7tx20c1.FriendMatch match;

  String hostName;

  String guestName;

  bool youAreHost;

  /// Returns a shallow copy of this [MatchView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MatchView copyWith({
    _i7tx20c1.FriendMatch? match,
    String? hostName,
    String? guestName,
    bool? youAreHost,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MatchView',
      'match': match.toJson(),
      'hostName': hostName,
      'guestName': guestName,
      'youAreHost': youAreHost,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MatchView',
      'match': match.toJsonForProtocol(),
      'hostName': hostName,
      'guestName': guestName,
      'youAreHost': youAreHost,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _MatchViewImpl extends MatchView {
  _MatchViewImpl({
    required _i7tx20c1.FriendMatch match,
    required String hostName,
    required String guestName,
    required bool youAreHost,
  }) : super._(
         match: match,
         hostName: hostName,
         guestName: guestName,
         youAreHost: youAreHost,
       );

  /// Returns a shallow copy of this [MatchView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MatchView copyWith({
    _i7tx20c1.FriendMatch? match,
    String? hostName,
    String? guestName,
    bool? youAreHost,
  }) {
    return MatchView(
      match: match ?? this.match.copyWith(),
      hostName: hostName ?? this.hostName,
      guestName: guestName ?? this.guestName,
      youAreHost: youAreHost ?? this.youAreHost,
    );
  }
}
