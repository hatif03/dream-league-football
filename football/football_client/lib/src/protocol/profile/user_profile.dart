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

/// Public game profile that sits next to a Serverpod auth user.
abstract class UserProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UserProfile._({
    this.id,
    required this.userId,
    required this.displayName,
    required this.displayNameLower,
    this.region,
    this.favouriteNation,
    DateTime? createdAt,
    this.bannedUntil,
    this.termsAcceptedAt,
    this.lastSeenAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfile({
    _isc.UuidValue? id,
    required String userId,
    required String displayName,
    required String displayNameLower,
    String? region,
    String? favouriteNation,
    DateTime? createdAt,
    DateTime? bannedUntil,
    DateTime? termsAcceptedAt,
    DateTime? lastSeenAt,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      displayName: jsonSerialization['displayName'] as String,
      displayNameLower: jsonSerialization['displayNameLower'] as String,
      region: jsonSerialization['region'] as String?,
      favouriteNation: jsonSerialization['favouriteNation'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      bannedUntil: jsonSerialization['bannedUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['bannedUntil'],
            ),
      termsAcceptedAt: jsonSerialization['termsAcceptedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['termsAcceptedAt'],
            ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSeenAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  /// The auth user's id (UUID string from session.authenticated.userIdentifier).
  String userId;

  /// Unique public name, shown as typed.
  String displayName;

  /// Lower-cased name, used for the case-insensitive unique index.
  String displayNameLower;

  String? region;

  /// Nation id the player supports.
  String? favouriteNation;

  DateTime createdAt;

  DateTime? bannedUntil;

  DateTime? termsAcceptedAt;

  /// Last time the signed-in app checked in; friends see an online dot while it is recent.
  DateTime? lastSeenAt;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserProfile copyWith({
    _isc.UuidValue? id,
    String? userId,
    String? displayName,
    String? displayNameLower,
    String? region,
    String? favouriteNation,
    DateTime? createdAt,
    DateTime? bannedUntil,
    DateTime? termsAcceptedAt,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'displayName': displayName,
      'displayNameLower': displayNameLower,
      if (region != null) 'region': region,
      if (favouriteNation != null) 'favouriteNation': favouriteNation,
      'createdAt': createdAt.toJson(),
      if (bannedUntil != null) 'bannedUntil': bannedUntil?.toJson(),
      if (termsAcceptedAt != null) 'termsAcceptedAt': termsAcceptedAt?.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'displayName': displayName,
      'displayNameLower': displayNameLower,
      if (region != null) 'region': region,
      if (favouriteNation != null) 'favouriteNation': favouriteNation,
      'createdAt': createdAt.toJson(),
      if (bannedUntil != null) 'bannedUntil': bannedUntil?.toJson(),
      if (termsAcceptedAt != null) 'termsAcceptedAt': termsAcceptedAt?.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    _isc.UuidValue? id,
    required String userId,
    required String displayName,
    required String displayNameLower,
    String? region,
    String? favouriteNation,
    DateTime? createdAt,
    DateTime? bannedUntil,
    DateTime? termsAcceptedAt,
    DateTime? lastSeenAt,
  }) : super._(
         id: id,
         userId: userId,
         displayName: displayName,
         displayNameLower: displayNameLower,
         region: region,
         favouriteNation: favouriteNation,
         createdAt: createdAt,
         bannedUntil: bannedUntil,
         termsAcceptedAt: termsAcceptedAt,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    String? userId,
    String? displayName,
    String? displayNameLower,
    Object? region = _Undefined,
    Object? favouriteNation = _Undefined,
    DateTime? createdAt,
    Object? bannedUntil = _Undefined,
    Object? termsAcceptedAt = _Undefined,
    Object? lastSeenAt = _Undefined,
  }) {
    return UserProfile(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      displayNameLower: displayNameLower ?? this.displayNameLower,
      region: region is String? ? region : this.region,
      favouriteNation: favouriteNation is String?
          ? favouriteNation
          : this.favouriteNation,
      createdAt: createdAt ?? this.createdAt,
      bannedUntil: bannedUntil is DateTime? ? bannedUntil : this.bannedUntil,
      termsAcceptedAt: termsAcceptedAt is DateTime?
          ? termsAcceptedAt
          : this.termsAcceptedAt,
      lastSeenAt: lastSeenAt is DateTime? ? lastSeenAt : this.lastSeenAt,
    );
  }
}
