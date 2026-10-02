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

/// The WebRTC handshake as the polling peer sees it.
abstract class SignalView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SignalView._({
    this.offer,
    this.answer,
    required this.status,
  });

  factory SignalView({
    String? offer,
    String? answer,
    required String status,
  }) = _SignalViewImpl;

  factory SignalView.fromJson(Map<String, dynamic> jsonSerialization) {
    return SignalView(
      offer: jsonSerialization['offer'] as String?,
      answer: jsonSerialization['answer'] as String?,
      status: jsonSerialization['status'] as String,
    );
  }

  String? offer;

  String? answer;

  String status;

  /// Returns a shallow copy of this [SignalView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SignalView copyWith({
    String? offer,
    String? answer,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SignalView',
      if (offer != null) 'offer': offer,
      if (answer != null) 'answer': answer,
      'status': status,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SignalView',
      if (offer != null) 'offer': offer,
      if (answer != null) 'answer': answer,
      'status': status,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SignalViewImpl extends SignalView {
  _SignalViewImpl({
    String? offer,
    String? answer,
    required String status,
  }) : super._(
         offer: offer,
         answer: answer,
         status: status,
       );

  /// Returns a shallow copy of this [SignalView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SignalView copyWith({
    Object? offer = _Undefined,
    Object? answer = _Undefined,
    String? status,
  }) {
    return SignalView(
      offer: offer is String? ? offer : this.offer,
      answer: answer is String? ? answer : this.answer,
      status: status ?? this.status,
    );
  }
}
