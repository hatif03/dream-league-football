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

/// A player waiting for matchmaking to find an opponent.
abstract class QueueEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QueueEntry._({
    this.id,
    required this.userId,
    required this.mode,
    required this.clientVersion,
    required this.rating,
    DateTime? joinedAt,
    required this.lastPollAt,
    this.lobbyId,
  }) : joinedAt = joinedAt ?? DateTime.now();

  factory QueueEntry({
    _isc.UuidValue? id,
    required String userId,
    required String mode,
    required String clientVersion,
    required int rating,
    DateTime? joinedAt,
    required DateTime lastPollAt,
    _isc.UuidValue? lobbyId,
  }) = _QueueEntryImpl;

  factory QueueEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueueEntry(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      mode: jsonSerialization['mode'] as String,
      clientVersion: jsonSerialization['clientVersion'] as String,
      rating: jsonSerialization['rating'] as int,
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
      lastPollAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastPollAt'],
      ),
      lobbyId: jsonSerialization['lobbyId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['lobbyId']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String userId;

  /// match | penalties
  String mode;

  String clientVersion;

  int rating;

  DateTime joinedAt;

  /// Updated while the player's page keeps asking; a silent entry is dropped.
  DateTime lastPollAt;

  /// Set when an opponent was found: the room both were seated in.
  _isc.UuidValue? lobbyId;

  /// Returns a shallow copy of this [QueueEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QueueEntry copyWith({
    _isc.UuidValue? id,
    String? userId,
    String? mode,
    String? clientVersion,
    int? rating,
    DateTime? joinedAt,
    DateTime? lastPollAt,
    _isc.UuidValue? lobbyId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QueueEntry',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'mode': mode,
      'clientVersion': clientVersion,
      'rating': rating,
      'joinedAt': joinedAt.toJson(),
      'lastPollAt': lastPollAt.toJson(),
      if (lobbyId != null) 'lobbyId': lobbyId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QueueEntry',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'mode': mode,
      'clientVersion': clientVersion,
      'rating': rating,
      'joinedAt': joinedAt.toJson(),
      'lastPollAt': lastPollAt.toJson(),
      if (lobbyId != null) 'lobbyId': lobbyId?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QueueEntryImpl extends QueueEntry {
  _QueueEntryImpl({
    _isc.UuidValue? id,
    required String userId,
    required String mode,
    required String clientVersion,
    required int rating,
    DateTime? joinedAt,
    required DateTime lastPollAt,
    _isc.UuidValue? lobbyId,
  }) : super._(
         id: id,
         userId: userId,
         mode: mode,
         clientVersion: clientVersion,
         rating: rating,
         joinedAt: joinedAt,
         lastPollAt: lastPollAt,
         lobbyId: lobbyId,
       );

  /// Returns a shallow copy of this [QueueEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QueueEntry copyWith({
    Object? id = _Undefined,
    String? userId,
    String? mode,
    String? clientVersion,
    int? rating,
    DateTime? joinedAt,
    DateTime? lastPollAt,
    Object? lobbyId = _Undefined,
  }) {
    return QueueEntry(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      mode: mode ?? this.mode,
      clientVersion: clientVersion ?? this.clientVersion,
      rating: rating ?? this.rating,
      joinedAt: joinedAt ?? this.joinedAt,
      lastPollAt: lastPollAt ?? this.lastPollAt,
      lobbyId: lobbyId is _isc.UuidValue? ? lobbyId : this.lobbyId,
    );
  }
}
