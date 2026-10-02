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

/// One chat line with the sender name filled in.
abstract class ChatLine
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ChatLine._({
    required this.id,
    required this.userId,
    required this.name,
    required this.text,
    required this.createdAt,
  });

  factory ChatLine({
    required _is.UuidValue id,
    required String userId,
    required String name,
    required String text,
    required DateTime createdAt,
  }) = _ChatLineImpl;

  factory ChatLine.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatLine(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      name: jsonSerialization['name'] as String,
      text: jsonSerialization['text'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _is.UuidValue id;

  String userId;

  String name;

  String text;

  DateTime createdAt;

  /// Returns a shallow copy of this [ChatLine]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ChatLine copyWith({
    _is.UuidValue? id,
    String? userId,
    String? name,
    String? text,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatLine',
      'id': id.toJson(),
      'userId': userId,
      'name': name,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChatLine',
      'id': id.toJson(),
      'userId': userId,
      'name': name,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ChatLineImpl extends ChatLine {
  _ChatLineImpl({
    required _is.UuidValue id,
    required String userId,
    required String name,
    required String text,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         text: text,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ChatLine]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChatLine copyWith({
    _is.UuidValue? id,
    String? userId,
    String? name,
    String? text,
    DateTime? createdAt,
  }) {
    return ChatLine(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
