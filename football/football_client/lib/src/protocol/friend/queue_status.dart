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
import 'package:football_client/src/protocol/protocol.dart' as _idscufu7;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../friend/lobby_view.dart' as _ibm2lkxy;

abstract class QueueStatus
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QueueStatus._({
    required this.searching,
    required this.waitedSecs,
    required this.mode,
    required this.queued,
    this.lobby,
  });

  factory QueueStatus({
    required bool searching,
    required int waitedSecs,
    required String mode,
    required int queued,
    _ibm2lkxy.LobbyView? lobby,
  }) = _QueueStatusImpl;

  factory QueueStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueueStatus(
      searching: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['searching'],
      ),
      waitedSecs: jsonSerialization['waitedSecs'] as int,
      mode: jsonSerialization['mode'] as String,
      queued: jsonSerialization['queued'] as int,
      lobby: jsonSerialization['lobby'] == null
          ? null
          : _idscufu7.Protocol().deserialize<_ibm2lkxy.LobbyView>(
              jsonSerialization['lobby'],
            ),
    );
  }

  bool searching;

  int waitedSecs;

  String mode;

  /// How many other players are waiting for the same kind of game.
  int queued;

  /// Set when an opponent was found.
  _ibm2lkxy.LobbyView? lobby;

  /// Returns a shallow copy of this [QueueStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QueueStatus copyWith({
    bool? searching,
    int? waitedSecs,
    String? mode,
    int? queued,
    _ibm2lkxy.LobbyView? lobby,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QueueStatus',
      'searching': searching,
      'waitedSecs': waitedSecs,
      'mode': mode,
      'queued': queued,
      if (lobby != null) 'lobby': lobby?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QueueStatus',
      'searching': searching,
      'waitedSecs': waitedSecs,
      'mode': mode,
      'queued': queued,
      if (lobby != null) 'lobby': lobby?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QueueStatusImpl extends QueueStatus {
  _QueueStatusImpl({
    required bool searching,
    required int waitedSecs,
    required String mode,
    required int queued,
    _ibm2lkxy.LobbyView? lobby,
  }) : super._(
         searching: searching,
         waitedSecs: waitedSecs,
         mode: mode,
         queued: queued,
         lobby: lobby,
       );

  /// Returns a shallow copy of this [QueueStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QueueStatus copyWith({
    bool? searching,
    int? waitedSecs,
    String? mode,
    int? queued,
    Object? lobby = _Undefined,
  }) {
    return QueueStatus(
      searching: searching ?? this.searching,
      waitedSecs: waitedSecs ?? this.waitedSecs,
      mode: mode ?? this.mode,
      queued: queued ?? this.queued,
      lobby: lobby is _ibm2lkxy.LobbyView? ? lobby : this.lobby?.copyWith(),
    );
  }
}
