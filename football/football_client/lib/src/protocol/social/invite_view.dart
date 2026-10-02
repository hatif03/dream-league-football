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

/// An invite into a room, as the invited player sees it.
abstract class InviteView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  InviteView._({
    required this.lobbyId,
    required this.code,
    required this.fromName,
    required this.createdAt,
  });

  factory InviteView({
    required _isc.UuidValue lobbyId,
    required String code,
    required String fromName,
    required DateTime createdAt,
  }) = _InviteViewImpl;

  factory InviteView.fromJson(Map<String, dynamic> jsonSerialization) {
    return InviteView(
      lobbyId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['lobbyId'],
      ),
      code: jsonSerialization['code'] as String,
      fromName: jsonSerialization['fromName'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _isc.UuidValue lobbyId;

  String code;

  String fromName;

  DateTime createdAt;

  /// Returns a shallow copy of this [InviteView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  InviteView copyWith({
    _isc.UuidValue? lobbyId,
    String? code,
    String? fromName,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InviteView',
      'lobbyId': lobbyId.toJson(),
      'code': code,
      'fromName': fromName,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InviteView',
      'lobbyId': lobbyId.toJson(),
      'code': code,
      'fromName': fromName,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _InviteViewImpl extends InviteView {
  _InviteViewImpl({
    required _isc.UuidValue lobbyId,
    required String code,
    required String fromName,
    required DateTime createdAt,
  }) : super._(
         lobbyId: lobbyId,
         code: code,
         fromName: fromName,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [InviteView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  InviteView copyWith({
    _isc.UuidValue? lobbyId,
    String? code,
    String? fromName,
    DateTime? createdAt,
  }) {
    return InviteView(
      lobbyId: lobbyId ?? this.lobbyId,
      code: code ?? this.code,
      fromName: fromName ?? this.fromName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
