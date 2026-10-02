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
import '../social/invite_view.dart' as _i72tdb7e;
import '../social/person_view.dart' as _iu3nz94a;

/// Everything the friends panel needs in one call.
abstract class FriendsView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  FriendsView._({
    required this.friends,
    required this.incoming,
    required this.outgoing,
    required this.blocked,
    required this.invites,
  });

  factory FriendsView({
    required List<_iu3nz94a.PersonView> friends,
    required List<_iu3nz94a.PersonView> incoming,
    required List<_iu3nz94a.PersonView> outgoing,
    required List<_iu3nz94a.PersonView> blocked,
    required List<_i72tdb7e.InviteView> invites,
  }) = _FriendsViewImpl;

  factory FriendsView.fromJson(Map<String, dynamic> jsonSerialization) {
    return FriendsView(
      friends: _irwjntvu.Protocol().deserialize<List<_iu3nz94a.PersonView>>(
        jsonSerialization['friends'],
      ),
      incoming: _irwjntvu.Protocol().deserialize<List<_iu3nz94a.PersonView>>(
        jsonSerialization['incoming'],
      ),
      outgoing: _irwjntvu.Protocol().deserialize<List<_iu3nz94a.PersonView>>(
        jsonSerialization['outgoing'],
      ),
      blocked: _irwjntvu.Protocol().deserialize<List<_iu3nz94a.PersonView>>(
        jsonSerialization['blocked'],
      ),
      invites: _irwjntvu.Protocol().deserialize<List<_i72tdb7e.InviteView>>(
        jsonSerialization['invites'],
      ),
    );
  }

  List<_iu3nz94a.PersonView> friends;

  List<_iu3nz94a.PersonView> incoming;

  List<_iu3nz94a.PersonView> outgoing;

  List<_iu3nz94a.PersonView> blocked;

  List<_i72tdb7e.InviteView> invites;

  /// Returns a shallow copy of this [FriendsView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FriendsView copyWith({
    List<_iu3nz94a.PersonView>? friends,
    List<_iu3nz94a.PersonView>? incoming,
    List<_iu3nz94a.PersonView>? outgoing,
    List<_iu3nz94a.PersonView>? blocked,
    List<_i72tdb7e.InviteView>? invites,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FriendsView',
      'friends': friends.toJson(valueToJson: (v) => v.toJson()),
      'incoming': incoming.toJson(valueToJson: (v) => v.toJson()),
      'outgoing': outgoing.toJson(valueToJson: (v) => v.toJson()),
      'blocked': blocked.toJson(valueToJson: (v) => v.toJson()),
      'invites': invites.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FriendsView',
      'friends': friends.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'incoming': incoming.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'outgoing': outgoing.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'blocked': blocked.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'invites': invites.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _FriendsViewImpl extends FriendsView {
  _FriendsViewImpl({
    required List<_iu3nz94a.PersonView> friends,
    required List<_iu3nz94a.PersonView> incoming,
    required List<_iu3nz94a.PersonView> outgoing,
    required List<_iu3nz94a.PersonView> blocked,
    required List<_i72tdb7e.InviteView> invites,
  }) : super._(
         friends: friends,
         incoming: incoming,
         outgoing: outgoing,
         blocked: blocked,
         invites: invites,
       );

  /// Returns a shallow copy of this [FriendsView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FriendsView copyWith({
    List<_iu3nz94a.PersonView>? friends,
    List<_iu3nz94a.PersonView>? incoming,
    List<_iu3nz94a.PersonView>? outgoing,
    List<_iu3nz94a.PersonView>? blocked,
    List<_i72tdb7e.InviteView>? invites,
  }) {
    return FriendsView(
      friends: friends ?? this.friends.map((e0) => e0.copyWith()).toList(),
      incoming: incoming ?? this.incoming.map((e0) => e0.copyWith()).toList(),
      outgoing: outgoing ?? this.outgoing.map((e0) => e0.copyWith()).toList(),
      blocked: blocked ?? this.blocked.map((e0) => e0.copyWith()).toList(),
      invites: invites ?? this.invites.map((e0) => e0.copyWith()).toList(),
    );
  }
}
