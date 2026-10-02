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

/// A line of lobby chat. Stored on the room so a late joiner still sees it.
abstract class LobbyMessage
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  LobbyMessage._({
    this.id,
    required this.lobbyId,
    required this.userId,
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LobbyMessage({
    _is.UuidValue? id,
    required _is.UuidValue lobbyId,
    required String userId,
    required String text,
    DateTime? createdAt,
  }) = _LobbyMessageImpl;

  factory LobbyMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return LobbyMessage(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      lobbyId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['lobbyId'],
      ),
      userId: jsonSerialization['userId'] as String,
      text: jsonSerialization['text'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = LobbyMessageTable();

  static const db = LobbyMessageRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue lobbyId;

  String userId;

  String text;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [LobbyMessage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LobbyMessage copyWith({
    _is.UuidValue? id,
    _is.UuidValue? lobbyId,
    String? userId,
    String? text,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LobbyMessage',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LobbyMessage',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  static LobbyMessageInclude include() {
    return LobbyMessageInclude._();
  }

  static LobbyMessageIncludeList includeList({
    _is.WhereExpressionBuilder<LobbyMessageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LobbyMessageTable>? orderBy,
    _is.OrderByListBuilder<LobbyMessageTable>? orderByList,
    LobbyMessageInclude? include,
  }) {
    return LobbyMessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LobbyMessage.t),
      orderByList: orderByList?.call(LobbyMessage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LobbyMessageImpl extends LobbyMessage {
  _LobbyMessageImpl({
    _is.UuidValue? id,
    required _is.UuidValue lobbyId,
    required String userId,
    required String text,
    DateTime? createdAt,
  }) : super._(
         id: id,
         lobbyId: lobbyId,
         userId: userId,
         text: text,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LobbyMessage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LobbyMessage copyWith({
    Object? id = _Undefined,
    _is.UuidValue? lobbyId,
    String? userId,
    String? text,
    DateTime? createdAt,
  }) {
    return LobbyMessage(
      id: id is _is.UuidValue? ? id : this.id,
      lobbyId: lobbyId ?? this.lobbyId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LobbyMessageUpdateTable extends _is.UpdateTable<LobbyMessageTable> {
  LobbyMessageUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> lobbyId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.lobbyId,
        value,
      );

  _is.ColumnValue<String, String> userId(String value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> text(String value) => _is.ColumnValue(
    table.text,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class LobbyMessageTable extends _is.Table<_is.UuidValue?> {
  LobbyMessageTable({super.tableRelation}) : super(tableName: 'lobby_message') {
    updateTable = LobbyMessageUpdateTable(this);
    lobbyId = _is.ColumnUuid(
      'lobbyId',
      this,
    );
    userId = _is.ColumnString(
      'userId',
      this,
    );
    text = _is.ColumnString(
      'text',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final LobbyMessageUpdateTable updateTable;

  late final _is.ColumnUuid lobbyId;

  late final _is.ColumnString userId;

  late final _is.ColumnString text;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    lobbyId,
    userId,
    text,
    createdAt,
  ];
}

class LobbyMessageInclude extends _is.IncludeObject {
  LobbyMessageInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => LobbyMessage.t;
}

class LobbyMessageIncludeList extends _is.IncludeList {
  LobbyMessageIncludeList._({
    _is.WhereExpressionBuilder<LobbyMessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LobbyMessage.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => LobbyMessage.t;
}

class LobbyMessageRepository {
  const LobbyMessageRepository._();

  /// Returns a list of [LobbyMessage]s matching the given query parameters.
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
  Future<List<LobbyMessage>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LobbyMessageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LobbyMessageTable>? orderBy,
    _is.OrderByListBuilder<LobbyMessageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LobbyMessage>(
      where: where?.call(LobbyMessage.t),
      orderBy: orderBy?.call(LobbyMessage.t),
      orderByList: orderByList?.call(LobbyMessage.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LobbyMessage] matching the given query parameters.
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
  Future<LobbyMessage?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LobbyMessageTable>? where,
    int? offset,
    _is.OrderByBuilder<LobbyMessageTable>? orderBy,
    _is.OrderByListBuilder<LobbyMessageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LobbyMessage>(
      where: where?.call(LobbyMessage.t),
      orderBy: orderBy?.call(LobbyMessage.t),
      orderByList: orderByList?.call(LobbyMessage.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LobbyMessage] by its [id] or null if no such row exists.
  Future<LobbyMessage?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LobbyMessage>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LobbyMessage]s in the list and returns the inserted rows.
  ///
  /// The returned [LobbyMessage]s will have their `id` fields set.
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
  Future<List<LobbyMessage>> insert(
    _is.DatabaseSession session,
    List<LobbyMessage> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LobbyMessage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LobbyMessage] and returns the inserted row.
  ///
  /// The returned [LobbyMessage] will have its `id` field set.
  Future<LobbyMessage> insertRow(
    _is.DatabaseSession session,
    LobbyMessage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LobbyMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LobbyMessage]s in the list and returns the resulting rows.
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
  /// The returned [LobbyMessage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LobbyMessage>> upsert(
    _is.DatabaseSession session,
    List<LobbyMessage> rows, {
    required _is.ColumnSelections<LobbyMessageTable> conflictColumns,
    _is.ColumnSelections<LobbyMessageTable>? updateColumns,
    _is.WhereExpressionBuilder<LobbyMessageTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LobbyMessage>(
      rows,
      conflictColumns: conflictColumns(LobbyMessage.t),
      updateColumns: updateColumns?.call(LobbyMessage.t),
      updateWhere: updateWhere?.call(LobbyMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LobbyMessage] and returns the resulting row.
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
  /// The returned [LobbyMessage] will have its `id` field set.
  Future<LobbyMessage?> upsertRow(
    _is.DatabaseSession session,
    LobbyMessage row, {
    required _is.ColumnSelections<LobbyMessageTable> conflictColumns,
    _is.ColumnSelections<LobbyMessageTable>? updateColumns,
    _is.WhereExpressionBuilder<LobbyMessageTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LobbyMessage>(
      row,
      conflictColumns: conflictColumns(LobbyMessage.t),
      updateColumns: updateColumns?.call(LobbyMessage.t),
      updateWhere: updateWhere?.call(LobbyMessage.t),
      transaction: transaction,
    );
  }

  /// Updates all [LobbyMessage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LobbyMessage>> update(
    _is.DatabaseSession session,
    List<LobbyMessage> rows, {
    _is.ColumnSelections<LobbyMessageTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LobbyMessage>(
      rows,
      columns: columns?.call(LobbyMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LobbyMessage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LobbyMessage> updateRow(
    _is.DatabaseSession session,
    LobbyMessage row, {
    _is.ColumnSelections<LobbyMessageTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LobbyMessage>(
      row,
      columns: columns?.call(LobbyMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LobbyMessage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LobbyMessage?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<LobbyMessageUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LobbyMessage>(
      id,
      columnValues: columnValues(LobbyMessage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LobbyMessage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LobbyMessage>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LobbyMessageUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LobbyMessageTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LobbyMessageTable>? orderBy,
    _is.OrderByListBuilder<LobbyMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LobbyMessage>(
      columnValues: columnValues(LobbyMessage.t.updateTable),
      where: where(LobbyMessage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LobbyMessage.t),
      orderByList: orderByList?.call(LobbyMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LobbyMessage]s in the list and returns the deleted rows.
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
  Future<List<LobbyMessage>> delete(
    _is.DatabaseSession session,
    List<LobbyMessage> rows, {
    _is.OrderByBuilder<LobbyMessageTable>? orderBy,
    _is.OrderByListBuilder<LobbyMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LobbyMessage>(
      rows,
      orderBy: orderBy?.call(LobbyMessage.t),
      orderByList: orderByList?.call(LobbyMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LobbyMessage].
  Future<LobbyMessage> deleteRow(
    _is.DatabaseSession session,
    LobbyMessage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LobbyMessage>(
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
  Future<List<LobbyMessage>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LobbyMessageTable> where,
    _is.OrderByBuilder<LobbyMessageTable>? orderBy,
    _is.OrderByListBuilder<LobbyMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LobbyMessage>(
      where: where(LobbyMessage.t),
      orderBy: orderBy?.call(LobbyMessage.t),
      orderByList: orderByList?.call(LobbyMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LobbyMessageTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LobbyMessage>(
      where: where?.call(LobbyMessage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LobbyMessage] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LobbyMessageTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LobbyMessage>(
      where: where(LobbyMessage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
