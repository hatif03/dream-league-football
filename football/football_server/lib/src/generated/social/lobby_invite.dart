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

/// A friend invited into a room. It lives as long as the room is open.
abstract class LobbyInvite
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  LobbyInvite._({
    this.id,
    required this.lobbyId,
    required this.fromUserId,
    required this.toUserId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LobbyInvite({
    _is.UuidValue? id,
    required _is.UuidValue lobbyId,
    required String fromUserId,
    required String toUserId,
    DateTime? createdAt,
  }) = _LobbyInviteImpl;

  factory LobbyInvite.fromJson(Map<String, dynamic> jsonSerialization) {
    return LobbyInvite(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      lobbyId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['lobbyId'],
      ),
      fromUserId: jsonSerialization['fromUserId'] as String,
      toUserId: jsonSerialization['toUserId'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = LobbyInviteTable();

  static const db = LobbyInviteRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue lobbyId;

  String fromUserId;

  String toUserId;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [LobbyInvite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LobbyInvite copyWith({
    _is.UuidValue? id,
    _is.UuidValue? lobbyId,
    String? fromUserId,
    String? toUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LobbyInvite',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LobbyInvite',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  static LobbyInviteInclude include() {
    return LobbyInviteInclude._();
  }

  static LobbyInviteIncludeList includeList({
    _is.WhereExpressionBuilder<LobbyInviteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LobbyInviteTable>? orderBy,
    _is.OrderByListBuilder<LobbyInviteTable>? orderByList,
    LobbyInviteInclude? include,
  }) {
    return LobbyInviteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LobbyInvite.t),
      orderByList: orderByList?.call(LobbyInvite.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LobbyInviteImpl extends LobbyInvite {
  _LobbyInviteImpl({
    _is.UuidValue? id,
    required _is.UuidValue lobbyId,
    required String fromUserId,
    required String toUserId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         lobbyId: lobbyId,
         fromUserId: fromUserId,
         toUserId: toUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LobbyInvite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LobbyInvite copyWith({
    Object? id = _Undefined,
    _is.UuidValue? lobbyId,
    String? fromUserId,
    String? toUserId,
    DateTime? createdAt,
  }) {
    return LobbyInvite(
      id: id is _is.UuidValue? ? id : this.id,
      lobbyId: lobbyId ?? this.lobbyId,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LobbyInviteUpdateTable extends _is.UpdateTable<LobbyInviteTable> {
  LobbyInviteUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> lobbyId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.lobbyId,
        value,
      );

  _is.ColumnValue<String, String> fromUserId(String value) => _is.ColumnValue(
    table.fromUserId,
    value,
  );

  _is.ColumnValue<String, String> toUserId(String value) => _is.ColumnValue(
    table.toUserId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class LobbyInviteTable extends _is.Table<_is.UuidValue?> {
  LobbyInviteTable({super.tableRelation}) : super(tableName: 'lobby_invite') {
    updateTable = LobbyInviteUpdateTable(this);
    lobbyId = _is.ColumnUuid(
      'lobbyId',
      this,
    );
    fromUserId = _is.ColumnString(
      'fromUserId',
      this,
    );
    toUserId = _is.ColumnString(
      'toUserId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final LobbyInviteUpdateTable updateTable;

  late final _is.ColumnUuid lobbyId;

  late final _is.ColumnString fromUserId;

  late final _is.ColumnString toUserId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    lobbyId,
    fromUserId,
    toUserId,
    createdAt,
  ];
}

class LobbyInviteInclude extends _is.IncludeObject {
  LobbyInviteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => LobbyInvite.t;
}

class LobbyInviteIncludeList extends _is.IncludeList {
  LobbyInviteIncludeList._({
    _is.WhereExpressionBuilder<LobbyInviteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LobbyInvite.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => LobbyInvite.t;
}

class LobbyInviteRepository {
  const LobbyInviteRepository._();

  /// Returns a list of [LobbyInvite]s matching the given query parameters.
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
  Future<List<LobbyInvite>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LobbyInviteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LobbyInviteTable>? orderBy,
    _is.OrderByListBuilder<LobbyInviteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LobbyInvite>(
      where: where?.call(LobbyInvite.t),
      orderBy: orderBy?.call(LobbyInvite.t),
      orderByList: orderByList?.call(LobbyInvite.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LobbyInvite] matching the given query parameters.
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
  Future<LobbyInvite?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LobbyInviteTable>? where,
    int? offset,
    _is.OrderByBuilder<LobbyInviteTable>? orderBy,
    _is.OrderByListBuilder<LobbyInviteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LobbyInvite>(
      where: where?.call(LobbyInvite.t),
      orderBy: orderBy?.call(LobbyInvite.t),
      orderByList: orderByList?.call(LobbyInvite.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LobbyInvite] by its [id] or null if no such row exists.
  Future<LobbyInvite?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LobbyInvite>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LobbyInvite]s in the list and returns the inserted rows.
  ///
  /// The returned [LobbyInvite]s will have their `id` fields set.
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
  Future<List<LobbyInvite>> insert(
    _is.DatabaseSession session,
    List<LobbyInvite> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LobbyInvite>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LobbyInvite] and returns the inserted row.
  ///
  /// The returned [LobbyInvite] will have its `id` field set.
  Future<LobbyInvite> insertRow(
    _is.DatabaseSession session,
    LobbyInvite row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LobbyInvite>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LobbyInvite]s in the list and returns the resulting rows.
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
  /// The returned [LobbyInvite]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LobbyInvite>> upsert(
    _is.DatabaseSession session,
    List<LobbyInvite> rows, {
    required _is.ColumnSelections<LobbyInviteTable> conflictColumns,
    _is.ColumnSelections<LobbyInviteTable>? updateColumns,
    _is.WhereExpressionBuilder<LobbyInviteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LobbyInvite>(
      rows,
      conflictColumns: conflictColumns(LobbyInvite.t),
      updateColumns: updateColumns?.call(LobbyInvite.t),
      updateWhere: updateWhere?.call(LobbyInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LobbyInvite] and returns the resulting row.
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
  /// The returned [LobbyInvite] will have its `id` field set.
  Future<LobbyInvite?> upsertRow(
    _is.DatabaseSession session,
    LobbyInvite row, {
    required _is.ColumnSelections<LobbyInviteTable> conflictColumns,
    _is.ColumnSelections<LobbyInviteTable>? updateColumns,
    _is.WhereExpressionBuilder<LobbyInviteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LobbyInvite>(
      row,
      conflictColumns: conflictColumns(LobbyInvite.t),
      updateColumns: updateColumns?.call(LobbyInvite.t),
      updateWhere: updateWhere?.call(LobbyInvite.t),
      transaction: transaction,
    );
  }

  /// Updates all [LobbyInvite]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LobbyInvite>> update(
    _is.DatabaseSession session,
    List<LobbyInvite> rows, {
    _is.ColumnSelections<LobbyInviteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LobbyInvite>(
      rows,
      columns: columns?.call(LobbyInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LobbyInvite]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LobbyInvite> updateRow(
    _is.DatabaseSession session,
    LobbyInvite row, {
    _is.ColumnSelections<LobbyInviteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LobbyInvite>(
      row,
      columns: columns?.call(LobbyInvite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LobbyInvite] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LobbyInvite?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<LobbyInviteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LobbyInvite>(
      id,
      columnValues: columnValues(LobbyInvite.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LobbyInvite]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LobbyInvite>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LobbyInviteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LobbyInviteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LobbyInviteTable>? orderBy,
    _is.OrderByListBuilder<LobbyInviteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LobbyInvite>(
      columnValues: columnValues(LobbyInvite.t.updateTable),
      where: where(LobbyInvite.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LobbyInvite.t),
      orderByList: orderByList?.call(LobbyInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LobbyInvite]s in the list and returns the deleted rows.
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
  Future<List<LobbyInvite>> delete(
    _is.DatabaseSession session,
    List<LobbyInvite> rows, {
    _is.OrderByBuilder<LobbyInviteTable>? orderBy,
    _is.OrderByListBuilder<LobbyInviteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LobbyInvite>(
      rows,
      orderBy: orderBy?.call(LobbyInvite.t),
      orderByList: orderByList?.call(LobbyInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LobbyInvite].
  Future<LobbyInvite> deleteRow(
    _is.DatabaseSession session,
    LobbyInvite row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LobbyInvite>(
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
  Future<List<LobbyInvite>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LobbyInviteTable> where,
    _is.OrderByBuilder<LobbyInviteTable>? orderBy,
    _is.OrderByListBuilder<LobbyInviteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LobbyInvite>(
      where: where(LobbyInvite.t),
      orderBy: orderBy?.call(LobbyInvite.t),
      orderByList: orderByList?.call(LobbyInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LobbyInviteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LobbyInvite>(
      where: where?.call(LobbyInvite.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LobbyInvite] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LobbyInviteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LobbyInvite>(
      where: where(LobbyInvite.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
