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

/// Public game profile that sits next to a Serverpod auth user.
abstract class UserProfile
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  UserProfile._({
    this.id,
    required this.userId,
    required this.displayName,
    required this.displayNameLower,
    this.region,
    this.avatar,
    this.settings,
    this.club,
    this.favouriteNation,
    DateTime? createdAt,
    this.bannedUntil,
    this.termsAcceptedAt,
    this.lastSeenAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfile({
    _is.UuidValue? id,
    required String userId,
    required String displayName,
    required String displayNameLower,
    String? region,
    int? avatar,
    String? settings,
    String? club,
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
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      displayName: jsonSerialization['displayName'] as String,
      displayNameLower: jsonSerialization['displayNameLower'] as String,
      region: jsonSerialization['region'] as String?,
      avatar: jsonSerialization['avatar'] as int?,
      settings: jsonSerialization['settings'] as String?,
      club: jsonSerialization['club'] as String?,
      favouriteNation: jsonSerialization['favouriteNation'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      bannedUntil: jsonSerialization['bannedUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['bannedUntil'],
            ),
      termsAcceptedAt: jsonSerialization['termsAcceptedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['termsAcceptedAt'],
            ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeenAt']),
    );
  }

  static final t = UserProfileTable();

  static const db = UserProfileRepository._();

  @override
  _is.UuidValue? id;

  /// The auth user's id (UUID string from session.authenticated.userIdentifier).
  String userId;

  /// Unique public name, shown as typed.
  String displayName;

  /// Lower-cased name, used for the case-insensitive unique index.
  String displayNameLower;

  String? region;

  /// Which of the pre-made avatars (0-23) the player picked; null until they choose.
  int? avatar;

  /// The player's saved settings (keys, formation, match length...) as JSON, so a new device picks them up.
  String? settings;

  /// The player's club crest and kit as JSON.
  String? club;

  /// Nation id the player supports.
  String? favouriteNation;

  DateTime createdAt;

  DateTime? bannedUntil;

  DateTime? termsAcceptedAt;

  /// Last time the signed-in app checked in; friends see an online dot while it is recent.
  DateTime? lastSeenAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserProfile copyWith({
    _is.UuidValue? id,
    String? userId,
    String? displayName,
    String? displayNameLower,
    String? region,
    int? avatar,
    String? settings,
    String? club,
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
      if (avatar != null) 'avatar': avatar,
      if (settings != null) 'settings': settings,
      if (club != null) 'club': club,
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
      if (avatar != null) 'avatar': avatar,
      if (settings != null) 'settings': settings,
      if (club != null) 'club': club,
      if (favouriteNation != null) 'favouriteNation': favouriteNation,
      'createdAt': createdAt.toJson(),
      if (bannedUntil != null) 'bannedUntil': bannedUntil?.toJson(),
      if (termsAcceptedAt != null) 'termsAcceptedAt': termsAcceptedAt?.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  static UserProfileInclude include() {
    return UserProfileInclude._();
  }

  static UserProfileIncludeList includeList({
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    UserProfileInclude? include,
  }) {
    return UserProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    _is.UuidValue? id,
    required String userId,
    required String displayName,
    required String displayNameLower,
    String? region,
    int? avatar,
    String? settings,
    String? club,
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
         avatar: avatar,
         settings: settings,
         club: club,
         favouriteNation: favouriteNation,
         createdAt: createdAt,
         bannedUntil: bannedUntil,
         termsAcceptedAt: termsAcceptedAt,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    String? userId,
    String? displayName,
    String? displayNameLower,
    Object? region = _Undefined,
    Object? avatar = _Undefined,
    Object? settings = _Undefined,
    Object? club = _Undefined,
    Object? favouriteNation = _Undefined,
    DateTime? createdAt,
    Object? bannedUntil = _Undefined,
    Object? termsAcceptedAt = _Undefined,
    Object? lastSeenAt = _Undefined,
  }) {
    return UserProfile(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      displayNameLower: displayNameLower ?? this.displayNameLower,
      region: region is String? ? region : this.region,
      avatar: avatar is int? ? avatar : this.avatar,
      settings: settings is String? ? settings : this.settings,
      club: club is String? ? club : this.club,
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

class UserProfileUpdateTable extends _is.UpdateTable<UserProfileTable> {
  UserProfileUpdateTable(super.table);

  _is.ColumnValue<String, String> userId(String value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<String, String> displayNameLower(String value) =>
      _is.ColumnValue(
        table.displayNameLower,
        value,
      );

  _is.ColumnValue<String, String> region(String? value) => _is.ColumnValue(
    table.region,
    value,
  );

  _is.ColumnValue<int, int> avatar(int? value) => _is.ColumnValue(
    table.avatar,
    value,
  );

  _is.ColumnValue<String, String> settings(String? value) => _is.ColumnValue(
    table.settings,
    value,
  );

  _is.ColumnValue<String, String> club(String? value) => _is.ColumnValue(
    table.club,
    value,
  );

  _is.ColumnValue<String, String> favouriteNation(String? value) =>
      _is.ColumnValue(
        table.favouriteNation,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> bannedUntil(DateTime? value) =>
      _is.ColumnValue(
        table.bannedUntil,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> termsAcceptedAt(DateTime? value) =>
      _is.ColumnValue(
        table.termsAcceptedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastSeenAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastSeenAt,
        value,
      );
}

class UserProfileTable extends _is.Table<_is.UuidValue?> {
  UserProfileTable({super.tableRelation}) : super(tableName: 'user_profile') {
    updateTable = UserProfileUpdateTable(this);
    userId = _is.ColumnString(
      'userId',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    displayNameLower = _is.ColumnString(
      'displayNameLower',
      this,
    );
    region = _is.ColumnString(
      'region',
      this,
    );
    avatar = _is.ColumnInt(
      'avatar',
      this,
    );
    settings = _is.ColumnString(
      'settings',
      this,
    );
    club = _is.ColumnString(
      'club',
      this,
    );
    favouriteNation = _is.ColumnString(
      'favouriteNation',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    bannedUntil = _is.ColumnDateTime(
      'bannedUntil',
      this,
    );
    termsAcceptedAt = _is.ColumnDateTime(
      'termsAcceptedAt',
      this,
    );
    lastSeenAt = _is.ColumnDateTime(
      'lastSeenAt',
      this,
    );
  }

  late final UserProfileUpdateTable updateTable;

  /// The auth user's id (UUID string from session.authenticated.userIdentifier).
  late final _is.ColumnString userId;

  /// Unique public name, shown as typed.
  late final _is.ColumnString displayName;

  /// Lower-cased name, used for the case-insensitive unique index.
  late final _is.ColumnString displayNameLower;

  late final _is.ColumnString region;

  /// Which of the pre-made avatars (0-23) the player picked; null until they choose.
  late final _is.ColumnInt avatar;

  /// The player's saved settings (keys, formation, match length...) as JSON, so a new device picks them up.
  late final _is.ColumnString settings;

  /// The player's club crest and kit as JSON.
  late final _is.ColumnString club;

  /// Nation id the player supports.
  late final _is.ColumnString favouriteNation;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime bannedUntil;

  late final _is.ColumnDateTime termsAcceptedAt;

  /// Last time the signed-in app checked in; friends see an online dot while it is recent.
  late final _is.ColumnDateTime lastSeenAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    displayName,
    displayNameLower,
    region,
    avatar,
    settings,
    club,
    favouriteNation,
    createdAt,
    bannedUntil,
    termsAcceptedAt,
    lastSeenAt,
  ];
}

class UserProfileInclude extends _is.IncludeObject {
  UserProfileInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => UserProfile.t;
}

class UserProfileIncludeList extends _is.IncludeList {
  UserProfileIncludeList._({
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserProfile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => UserProfile.t;
}

class UserProfileRepository {
  const UserProfileRepository._();

  /// Returns a list of [UserProfile]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<UserProfile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserProfile] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<UserProfile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserProfile] by its [id] or null if no such row exists.
  Future<UserProfile?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserProfile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfile>> insert(
    _is.DatabaseSession session,
    List<UserProfile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserProfile] and returns the inserted row.
  ///
  /// The returned [UserProfile] will have its `id` field set.
  Future<UserProfile> insertRow(
    _is.DatabaseSession session,
    UserProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserProfile]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [UserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfile>> upsert(
    _is.DatabaseSession session,
    List<UserProfile> rows, {
    required _is.ColumnSelections<UserProfileTable> conflictColumns,
    _is.ColumnSelections<UserProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<UserProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserProfile>(
      rows,
      conflictColumns: conflictColumns(UserProfile.t),
      updateColumns: updateColumns?.call(UserProfile.t),
      updateWhere: updateWhere?.call(UserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserProfile] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [UserProfile] will have its `id` field set.
  Future<UserProfile?> upsertRow(
    _is.DatabaseSession session,
    UserProfile row, {
    required _is.ColumnSelections<UserProfileTable> conflictColumns,
    _is.ColumnSelections<UserProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<UserProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserProfile>(
      row,
      conflictColumns: conflictColumns(UserProfile.t),
      updateColumns: updateColumns?.call(UserProfile.t),
      updateWhere: updateWhere?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfile>> update(
    _is.DatabaseSession session,
    List<UserProfile> rows, {
    _is.ColumnSelections<UserProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserProfile>(
      rows,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfile> updateRow(
    _is.DatabaseSession session,
    UserProfile row, {
    _is.ColumnSelections<UserProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfile>(
      row,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserProfile?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserProfile>(
      id,
      columnValues: columnValues(UserProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserProfile>(
      columnValues: columnValues(UserProfile.t.updateTable),
      where: where(UserProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserProfile]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfile>> delete(
    _is.DatabaseSession session,
    List<UserProfile> rows, {
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserProfile>(
      rows,
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserProfile].
  Future<UserProfile> deleteRow(
    _is.DatabaseSession session,
    UserProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserProfile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserProfileTable> where,
    _is.OrderByBuilder<UserProfileTable>? orderBy,
    _is.OrderByListBuilder<UserProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserProfile>(
      where: where(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserProfile>(
      where: where?.call(UserProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserProfile>(
      where: where(UserProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
