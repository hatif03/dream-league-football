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

/// A room where two players pick nations and ready up for a friend match.
abstract class Lobby
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Lobby._({
    this.id,
    required this.code,
    required this.hostUserId,
    this.guestUserId,
    this.hostNation,
    this.guestNation,
    required this.hostReady,
    required this.guestReady,
    required this.status,
    required this.clientVersion,
    this.matchId,
    this.rematchLobbyId,
    DateTime? createdAt,
    required this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Lobby({
    _is.UuidValue? id,
    required String code,
    required String hostUserId,
    String? guestUserId,
    String? hostNation,
    String? guestNation,
    required bool hostReady,
    required bool guestReady,
    required String status,
    required String clientVersion,
    _is.UuidValue? matchId,
    _is.UuidValue? rematchLobbyId,
    DateTime? createdAt,
    required DateTime updatedAt,
  }) = _LobbyImpl;

  factory Lobby.fromJson(Map<String, dynamic> jsonSerialization) {
    return Lobby(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      hostUserId: jsonSerialization['hostUserId'] as String,
      guestUserId: jsonSerialization['guestUserId'] as String?,
      hostNation: jsonSerialization['hostNation'] as String?,
      guestNation: jsonSerialization['guestNation'] as String?,
      hostReady: _is.BoolJsonExtension.fromJson(jsonSerialization['hostReady']),
      guestReady: _is.BoolJsonExtension.fromJson(
        jsonSerialization['guestReady'],
      ),
      status: jsonSerialization['status'] as String,
      clientVersion: jsonSerialization['clientVersion'] as String,
      matchId: jsonSerialization['matchId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['matchId']),
      rematchLobbyId: jsonSerialization['rematchLobbyId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['rematchLobbyId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = LobbyTable();

  static const db = LobbyRepository._();

  @override
  _is.UuidValue? id;

  /// Short code a friend types to join.
  String code;

  String hostUserId;

  String? guestUserId;

  String? hostNation;

  String? guestNation;

  bool hostReady;

  bool guestReady;

  /// open | live | closed
  String status;

  /// Both players must run the same build; the join is refused otherwise.
  String clientVersion;

  /// Set when both are ready and the match row exists.
  _is.UuidValue? matchId;

  /// Set when a player starts a rematch from the finished match.
  _is.UuidValue? rematchLobbyId;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Lobby]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Lobby copyWith({
    _is.UuidValue? id,
    String? code,
    String? hostUserId,
    String? guestUserId,
    String? hostNation,
    String? guestNation,
    bool? hostReady,
    bool? guestReady,
    String? status,
    String? clientVersion,
    _is.UuidValue? matchId,
    _is.UuidValue? rematchLobbyId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Lobby',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      'hostUserId': hostUserId,
      if (guestUserId != null) 'guestUserId': guestUserId,
      if (hostNation != null) 'hostNation': hostNation,
      if (guestNation != null) 'guestNation': guestNation,
      'hostReady': hostReady,
      'guestReady': guestReady,
      'status': status,
      'clientVersion': clientVersion,
      if (matchId != null) 'matchId': matchId?.toJson(),
      if (rematchLobbyId != null) 'rematchLobbyId': rematchLobbyId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Lobby',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      'hostUserId': hostUserId,
      if (guestUserId != null) 'guestUserId': guestUserId,
      if (hostNation != null) 'hostNation': hostNation,
      if (guestNation != null) 'guestNation': guestNation,
      'hostReady': hostReady,
      'guestReady': guestReady,
      'status': status,
      'clientVersion': clientVersion,
      if (matchId != null) 'matchId': matchId?.toJson(),
      if (rematchLobbyId != null) 'rematchLobbyId': rematchLobbyId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static LobbyInclude include() {
    return LobbyInclude._();
  }

  static LobbyIncludeList includeList({
    _is.WhereExpressionBuilder<LobbyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LobbyTable>? orderBy,
    _is.OrderByListBuilder<LobbyTable>? orderByList,
    LobbyInclude? include,
  }) {
    return LobbyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Lobby.t),
      orderByList: orderByList?.call(Lobby.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LobbyImpl extends Lobby {
  _LobbyImpl({
    _is.UuidValue? id,
    required String code,
    required String hostUserId,
    String? guestUserId,
    String? hostNation,
    String? guestNation,
    required bool hostReady,
    required bool guestReady,
    required String status,
    required String clientVersion,
    _is.UuidValue? matchId,
    _is.UuidValue? rematchLobbyId,
    DateTime? createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         hostUserId: hostUserId,
         guestUserId: guestUserId,
         hostNation: hostNation,
         guestNation: guestNation,
         hostReady: hostReady,
         guestReady: guestReady,
         status: status,
         clientVersion: clientVersion,
         matchId: matchId,
         rematchLobbyId: rematchLobbyId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Lobby]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Lobby copyWith({
    Object? id = _Undefined,
    String? code,
    String? hostUserId,
    Object? guestUserId = _Undefined,
    Object? hostNation = _Undefined,
    Object? guestNation = _Undefined,
    bool? hostReady,
    bool? guestReady,
    String? status,
    String? clientVersion,
    Object? matchId = _Undefined,
    Object? rematchLobbyId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Lobby(
      id: id is _is.UuidValue? ? id : this.id,
      code: code ?? this.code,
      hostUserId: hostUserId ?? this.hostUserId,
      guestUserId: guestUserId is String? ? guestUserId : this.guestUserId,
      hostNation: hostNation is String? ? hostNation : this.hostNation,
      guestNation: guestNation is String? ? guestNation : this.guestNation,
      hostReady: hostReady ?? this.hostReady,
      guestReady: guestReady ?? this.guestReady,
      status: status ?? this.status,
      clientVersion: clientVersion ?? this.clientVersion,
      matchId: matchId is _is.UuidValue? ? matchId : this.matchId,
      rematchLobbyId: rematchLobbyId is _is.UuidValue?
          ? rematchLobbyId
          : this.rematchLobbyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LobbyUpdateTable extends _is.UpdateTable<LobbyTable> {
  LobbyUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> hostUserId(String value) => _is.ColumnValue(
    table.hostUserId,
    value,
  );

  _is.ColumnValue<String, String> guestUserId(String? value) => _is.ColumnValue(
    table.guestUserId,
    value,
  );

  _is.ColumnValue<String, String> hostNation(String? value) => _is.ColumnValue(
    table.hostNation,
    value,
  );

  _is.ColumnValue<String, String> guestNation(String? value) => _is.ColumnValue(
    table.guestNation,
    value,
  );

  _is.ColumnValue<bool, bool> hostReady(bool value) => _is.ColumnValue(
    table.hostReady,
    value,
  );

  _is.ColumnValue<bool, bool> guestReady(bool value) => _is.ColumnValue(
    table.guestReady,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> clientVersion(String value) =>
      _is.ColumnValue(
        table.clientVersion,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> matchId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.matchId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> rematchLobbyId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.rematchLobbyId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class LobbyTable extends _is.Table<_is.UuidValue?> {
  LobbyTable({super.tableRelation}) : super(tableName: 'lobby') {
    updateTable = LobbyUpdateTable(this);
    code = _is.ColumnString(
      'code',
      this,
    );
    hostUserId = _is.ColumnString(
      'hostUserId',
      this,
    );
    guestUserId = _is.ColumnString(
      'guestUserId',
      this,
    );
    hostNation = _is.ColumnString(
      'hostNation',
      this,
    );
    guestNation = _is.ColumnString(
      'guestNation',
      this,
    );
    hostReady = _is.ColumnBool(
      'hostReady',
      this,
    );
    guestReady = _is.ColumnBool(
      'guestReady',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    clientVersion = _is.ColumnString(
      'clientVersion',
      this,
    );
    matchId = _is.ColumnUuid(
      'matchId',
      this,
    );
    rematchLobbyId = _is.ColumnUuid(
      'rematchLobbyId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final LobbyUpdateTable updateTable;

  /// Short code a friend types to join.
  late final _is.ColumnString code;

  late final _is.ColumnString hostUserId;

  late final _is.ColumnString guestUserId;

  late final _is.ColumnString hostNation;

  late final _is.ColumnString guestNation;

  late final _is.ColumnBool hostReady;

  late final _is.ColumnBool guestReady;

  /// open | live | closed
  late final _is.ColumnString status;

  /// Both players must run the same build; the join is refused otherwise.
  late final _is.ColumnString clientVersion;

  /// Set when both are ready and the match row exists.
  late final _is.ColumnUuid matchId;

  /// Set when a player starts a rematch from the finished match.
  late final _is.ColumnUuid rematchLobbyId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    hostUserId,
    guestUserId,
    hostNation,
    guestNation,
    hostReady,
    guestReady,
    status,
    clientVersion,
    matchId,
    rematchLobbyId,
    createdAt,
    updatedAt,
  ];
}

class LobbyInclude extends _is.IncludeObject {
  LobbyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Lobby.t;
}

class LobbyIncludeList extends _is.IncludeList {
  LobbyIncludeList._({
    _is.WhereExpressionBuilder<LobbyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Lobby.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Lobby.t;
}

class LobbyRepository {
  const LobbyRepository._();

  /// Returns a list of [Lobby]s matching the given query parameters.
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
  Future<List<Lobby>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LobbyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LobbyTable>? orderBy,
    _is.OrderByListBuilder<LobbyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Lobby>(
      where: where?.call(Lobby.t),
      orderBy: orderBy?.call(Lobby.t),
      orderByList: orderByList?.call(Lobby.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Lobby] matching the given query parameters.
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
  Future<Lobby?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LobbyTable>? where,
    int? offset,
    _is.OrderByBuilder<LobbyTable>? orderBy,
    _is.OrderByListBuilder<LobbyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Lobby>(
      where: where?.call(Lobby.t),
      orderBy: orderBy?.call(Lobby.t),
      orderByList: orderByList?.call(Lobby.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Lobby] by its [id] or null if no such row exists.
  Future<Lobby?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Lobby>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Lobby]s in the list and returns the inserted rows.
  ///
  /// The returned [Lobby]s will have their `id` fields set.
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
  Future<List<Lobby>> insert(
    _is.DatabaseSession session,
    List<Lobby> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Lobby>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Lobby] and returns the inserted row.
  ///
  /// The returned [Lobby] will have its `id` field set.
  Future<Lobby> insertRow(
    _is.DatabaseSession session,
    Lobby row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Lobby>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Lobby]s in the list and returns the resulting rows.
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
  /// The returned [Lobby]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Lobby>> upsert(
    _is.DatabaseSession session,
    List<Lobby> rows, {
    required _is.ColumnSelections<LobbyTable> conflictColumns,
    _is.ColumnSelections<LobbyTable>? updateColumns,
    _is.WhereExpressionBuilder<LobbyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Lobby>(
      rows,
      conflictColumns: conflictColumns(Lobby.t),
      updateColumns: updateColumns?.call(Lobby.t),
      updateWhere: updateWhere?.call(Lobby.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Lobby] and returns the resulting row.
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
  /// The returned [Lobby] will have its `id` field set.
  Future<Lobby?> upsertRow(
    _is.DatabaseSession session,
    Lobby row, {
    required _is.ColumnSelections<LobbyTable> conflictColumns,
    _is.ColumnSelections<LobbyTable>? updateColumns,
    _is.WhereExpressionBuilder<LobbyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Lobby>(
      row,
      conflictColumns: conflictColumns(Lobby.t),
      updateColumns: updateColumns?.call(Lobby.t),
      updateWhere: updateWhere?.call(Lobby.t),
      transaction: transaction,
    );
  }

  /// Updates all [Lobby]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Lobby>> update(
    _is.DatabaseSession session,
    List<Lobby> rows, {
    _is.ColumnSelections<LobbyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Lobby>(
      rows,
      columns: columns?.call(Lobby.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Lobby]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Lobby> updateRow(
    _is.DatabaseSession session,
    Lobby row, {
    _is.ColumnSelections<LobbyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Lobby>(
      row,
      columns: columns?.call(Lobby.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Lobby] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Lobby?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<LobbyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Lobby>(
      id,
      columnValues: columnValues(Lobby.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Lobby]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Lobby>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LobbyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LobbyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LobbyTable>? orderBy,
    _is.OrderByListBuilder<LobbyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Lobby>(
      columnValues: columnValues(Lobby.t.updateTable),
      where: where(Lobby.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Lobby.t),
      orderByList: orderByList?.call(Lobby.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Lobby]s in the list and returns the deleted rows.
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
  Future<List<Lobby>> delete(
    _is.DatabaseSession session,
    List<Lobby> rows, {
    _is.OrderByBuilder<LobbyTable>? orderBy,
    _is.OrderByListBuilder<LobbyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Lobby>(
      rows,
      orderBy: orderBy?.call(Lobby.t),
      orderByList: orderByList?.call(Lobby.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Lobby].
  Future<Lobby> deleteRow(
    _is.DatabaseSession session,
    Lobby row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Lobby>(
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
  Future<List<Lobby>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LobbyTable> where,
    _is.OrderByBuilder<LobbyTable>? orderBy,
    _is.OrderByListBuilder<LobbyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Lobby>(
      where: where(Lobby.t),
      orderBy: orderBy?.call(Lobby.t),
      orderByList: orderByList?.call(Lobby.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LobbyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Lobby>(
      where: where?.call(Lobby.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Lobby] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LobbyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Lobby>(
      where: where(Lobby.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
