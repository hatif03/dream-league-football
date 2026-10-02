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

/// An invite into a room, as the invited player sees it.
abstract class InviteView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  InviteView._({
    required this.lobbyId,
    required this.code,
    required this.fromName,
    required this.createdAt,
  });

  factory InviteView({
    required _is.UuidValue lobbyId,
    required String code,
    required String fromName,
    required DateTime createdAt,
  }) = _InviteViewImpl;

  factory InviteView.fromJson(Map<String, dynamic> jsonSerialization) {
    return InviteView(
      lobbyId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['lobbyId'],
      ),
      code: jsonSerialization['code'] as String,
      fromName: jsonSerialization['fromName'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _is.UuidValue lobbyId;

  String code;

  String fromName;

  DateTime createdAt;

  /// Returns a shallow copy of this [InviteView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InviteView copyWith({
    _is.UuidValue? lobbyId,
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
    return _is.SerializationManager.encode(this);
  }
}

class _InviteViewImpl extends InviteView {
  _InviteViewImpl({
    required _is.UuidValue lobbyId,
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
  @_is.useResult
  @override
  InviteView copyWith({
    _is.UuidValue? lobbyId,
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
