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
import '../friend/lobby.dart' as _iuq5c2ya;

/// A lobby plus the names the screen needs.
abstract class LobbyView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LobbyView._({
    required this.lobby,
    required this.hostName,
    this.hostAvatar,
    this.guestAvatar,
    this.guestName,
    required this.youAreHost,
  });

  factory LobbyView({
    required _iuq5c2ya.Lobby lobby,
    required String hostName,
    int? hostAvatar,
    int? guestAvatar,
    String? guestName,
    required bool youAreHost,
  }) = _LobbyViewImpl;

  factory LobbyView.fromJson(Map<String, dynamic> jsonSerialization) {
    return LobbyView(
      lobby: _irwjntvu.Protocol().deserialize<_iuq5c2ya.Lobby>(
        jsonSerialization['lobby'],
      ),
      hostName: jsonSerialization['hostName'] as String,
      hostAvatar: jsonSerialization['hostAvatar'] as int?,
      guestAvatar: jsonSerialization['guestAvatar'] as int?,
      guestName: jsonSerialization['guestName'] as String?,
      youAreHost: _is.BoolJsonExtension.fromJson(
        jsonSerialization['youAreHost'],
      ),
    );
  }

  _iuq5c2ya.Lobby lobby;

  String hostName;

  int? hostAvatar;

  int? guestAvatar;

  String? guestName;

  bool youAreHost;

  /// Returns a shallow copy of this [LobbyView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LobbyView copyWith({
    _iuq5c2ya.Lobby? lobby,
    String? hostName,
    int? hostAvatar,
    int? guestAvatar,
    String? guestName,
    bool? youAreHost,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LobbyView',
      'lobby': lobby.toJson(),
      'hostName': hostName,
      if (hostAvatar != null) 'hostAvatar': hostAvatar,
      if (guestAvatar != null) 'guestAvatar': guestAvatar,
      if (guestName != null) 'guestName': guestName,
      'youAreHost': youAreHost,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LobbyView',
      'lobby': lobby.toJsonForProtocol(),
      'hostName': hostName,
      if (hostAvatar != null) 'hostAvatar': hostAvatar,
      if (guestAvatar != null) 'guestAvatar': guestAvatar,
      if (guestName != null) 'guestName': guestName,
      'youAreHost': youAreHost,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LobbyViewImpl extends LobbyView {
  _LobbyViewImpl({
    required _iuq5c2ya.Lobby lobby,
    required String hostName,
    int? hostAvatar,
    int? guestAvatar,
    String? guestName,
    required bool youAreHost,
  }) : super._(
         lobby: lobby,
         hostName: hostName,
         hostAvatar: hostAvatar,
         guestAvatar: guestAvatar,
         guestName: guestName,
         youAreHost: youAreHost,
       );

  /// Returns a shallow copy of this [LobbyView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LobbyView copyWith({
    _iuq5c2ya.Lobby? lobby,
    String? hostName,
    Object? hostAvatar = _Undefined,
    Object? guestAvatar = _Undefined,
    Object? guestName = _Undefined,
    bool? youAreHost,
  }) {
    return LobbyView(
      lobby: lobby ?? this.lobby.copyWith(),
      hostName: hostName ?? this.hostName,
      hostAvatar: hostAvatar is int? ? hostAvatar : this.hostAvatar,
      guestAvatar: guestAvatar is int? ? guestAvatar : this.guestAvatar,
      guestName: guestName is String? ? guestName : this.guestName,
      youAreHost: youAreHost ?? this.youAreHost,
    );
  }
}
