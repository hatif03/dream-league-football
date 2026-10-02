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

/// A player as shown in friend lists and chat.
abstract class PersonView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PersonView._({
    required this.userId,
    required this.name,
    required this.online,
  });

  factory PersonView({
    required String userId,
    required String name,
    required bool online,
  }) = _PersonViewImpl;

  factory PersonView.fromJson(Map<String, dynamic> jsonSerialization) {
    return PersonView(
      userId: jsonSerialization['userId'] as String,
      name: jsonSerialization['name'] as String,
      online: _is.BoolJsonExtension.fromJson(jsonSerialization['online']),
    );
  }

  String userId;

  String name;

  /// Checked in within the last minute or so.
  bool online;

  /// Returns a shallow copy of this [PersonView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PersonView copyWith({
    String? userId,
    String? name,
    bool? online,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PersonView',
      'userId': userId,
      'name': name,
      'online': online,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PersonView',
      'userId': userId,
      'name': name,
      'online': online,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PersonViewImpl extends PersonView {
  _PersonViewImpl({
    required String userId,
    required String name,
    required bool online,
  }) : super._(
         userId: userId,
         name: name,
         online: online,
       );

  /// Returns a shallow copy of this [PersonView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PersonView copyWith({
    String? userId,
    String? name,
    bool? online,
  }) {
    return PersonView(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      online: online ?? this.online,
    );
  }
}
