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

/// Single row of switches the operators can flip without a deploy.
abstract class LiveOps
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  LiveOps._({
    this.id,
    required this.maintenance,
    this.message,
    required this.updatedAt,
  });

  factory LiveOps({
    _is.UuidValue? id,
    required bool maintenance,
    String? message,
    required DateTime updatedAt,
  }) = _LiveOpsImpl;

  factory LiveOps.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveOps(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      maintenance: _is.BoolJsonExtension.fromJson(
        jsonSerialization['maintenance'],
      ),
      message: jsonSerialization['message'] as String?,
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = LiveOpsTable();

  static const db = LiveOpsRepository._();

  @override
  _is.UuidValue? id;

  /// While true no new rooms open; players can still sign in and play on.
  bool maintenance;

  String? message;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [LiveOps]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveOps copyWith({
    _is.UuidValue? id,
    bool? maintenance,
    String? message,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveOps',
      if (id != null) 'id': id?.toJson(),
      'maintenance': maintenance,
      if (message != null) 'message': message,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LiveOps',
      if (id != null) 'id': id?.toJson(),
      'maintenance': maintenance,
      if (message != null) 'message': message,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static LiveOpsInclude include() {
    return LiveOpsInclude._();
  }

  static LiveOpsIncludeList includeList({
    _is.WhereExpressionBuilder<LiveOpsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LiveOpsTable>? orderBy,
    _is.OrderByListBuilder<LiveOpsTable>? orderByList,
    LiveOpsInclude? include,
  }) {
    return LiveOpsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LiveOps.t),
      orderByList: orderByList?.call(LiveOps.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LiveOpsImpl extends LiveOps {
  _LiveOpsImpl({
    _is.UuidValue? id,
    required bool maintenance,
    String? message,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         maintenance: maintenance,
         message: message,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LiveOps]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveOps copyWith({
    Object? id = _Undefined,
    bool? maintenance,
    Object? message = _Undefined,
    DateTime? updatedAt,
  }) {
    return LiveOps(
      id: id is _is.UuidValue? ? id : this.id,
      maintenance: maintenance ?? this.maintenance,
      message: message is String? ? message : this.message,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LiveOpsUpdateTable extends _is.UpdateTable<LiveOpsTable> {
  LiveOpsUpdateTable(super.table);

  _is.ColumnValue<bool, bool> maintenance(bool value) => _is.ColumnValue(
    table.maintenance,
    value,
  );

  _is.ColumnValue<String, String> message(String? value) => _is.ColumnValue(
    table.message,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class LiveOpsTable extends _is.Table<_is.UuidValue?> {
  LiveOpsTable({super.tableRelation}) : super(tableName: 'live_ops') {
    updateTable = LiveOpsUpdateTable(this);
    maintenance = _is.ColumnBool(
      'maintenance',
      this,
    );
    message = _is.ColumnString(
      'message',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final LiveOpsUpdateTable updateTable;

  /// While true no new rooms open; players can still sign in and play on.
  late final _is.ColumnBool maintenance;

  late final _is.ColumnString message;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    maintenance,
    message,
    updatedAt,
  ];
}

class LiveOpsInclude extends _is.IncludeObject {
  LiveOpsInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => LiveOps.t;
}

class LiveOpsIncludeList extends _is.IncludeList {
  LiveOpsIncludeList._({
    _is.WhereExpressionBuilder<LiveOpsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LiveOps.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => LiveOps.t;
}

class LiveOpsRepository {
  const LiveOpsRepository._();

  /// Returns a list of [LiveOps]s matching the given query parameters.
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
  Future<List<LiveOps>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LiveOpsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LiveOpsTable>? orderBy,
    _is.OrderByListBuilder<LiveOpsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LiveOps>(
      where: where?.call(LiveOps.t),
      orderBy: orderBy?.call(LiveOps.t),
      orderByList: orderByList?.call(LiveOps.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LiveOps] matching the given query parameters.
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
  Future<LiveOps?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LiveOpsTable>? where,
    int? offset,
    _is.OrderByBuilder<LiveOpsTable>? orderBy,
    _is.OrderByListBuilder<LiveOpsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LiveOps>(
      where: where?.call(LiveOps.t),
      orderBy: orderBy?.call(LiveOps.t),
      orderByList: orderByList?.call(LiveOps.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LiveOps] by its [id] or null if no such row exists.
  Future<LiveOps?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LiveOps>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LiveOps]s in the list and returns the inserted rows.
  ///
  /// The returned [LiveOps]s will have their `id` fields set.
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
  Future<List<LiveOps>> insert(
    _is.DatabaseSession session,
    List<LiveOps> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LiveOps>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LiveOps] and returns the inserted row.
  ///
  /// The returned [LiveOps] will have its `id` field set.
  Future<LiveOps> insertRow(
    _is.DatabaseSession session,
    LiveOps row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LiveOps>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LiveOps]s in the list and returns the resulting rows.
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
  /// The returned [LiveOps]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LiveOps>> upsert(
    _is.DatabaseSession session,
    List<LiveOps> rows, {
    required _is.ColumnSelections<LiveOpsTable> conflictColumns,
    _is.ColumnSelections<LiveOpsTable>? updateColumns,
    _is.WhereExpressionBuilder<LiveOpsTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LiveOps>(
      rows,
      conflictColumns: conflictColumns(LiveOps.t),
      updateColumns: updateColumns?.call(LiveOps.t),
      updateWhere: updateWhere?.call(LiveOps.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LiveOps] and returns the resulting row.
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
  /// The returned [LiveOps] will have its `id` field set.
  Future<LiveOps?> upsertRow(
    _is.DatabaseSession session,
    LiveOps row, {
    required _is.ColumnSelections<LiveOpsTable> conflictColumns,
    _is.ColumnSelections<LiveOpsTable>? updateColumns,
    _is.WhereExpressionBuilder<LiveOpsTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LiveOps>(
      row,
      conflictColumns: conflictColumns(LiveOps.t),
      updateColumns: updateColumns?.call(LiveOps.t),
      updateWhere: updateWhere?.call(LiveOps.t),
      transaction: transaction,
    );
  }

  /// Updates all [LiveOps]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LiveOps>> update(
    _is.DatabaseSession session,
    List<LiveOps> rows, {
    _is.ColumnSelections<LiveOpsTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LiveOps>(
      rows,
      columns: columns?.call(LiveOps.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LiveOps]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LiveOps> updateRow(
    _is.DatabaseSession session,
    LiveOps row, {
    _is.ColumnSelections<LiveOpsTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LiveOps>(
      row,
      columns: columns?.call(LiveOps.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LiveOps] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LiveOps?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<LiveOpsUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LiveOps>(
      id,
      columnValues: columnValues(LiveOps.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LiveOps]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LiveOps>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LiveOpsUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LiveOpsTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LiveOpsTable>? orderBy,
    _is.OrderByListBuilder<LiveOpsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LiveOps>(
      columnValues: columnValues(LiveOps.t.updateTable),
      where: where(LiveOps.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LiveOps.t),
      orderByList: orderByList?.call(LiveOps.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LiveOps]s in the list and returns the deleted rows.
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
  Future<List<LiveOps>> delete(
    _is.DatabaseSession session,
    List<LiveOps> rows, {
    _is.OrderByBuilder<LiveOpsTable>? orderBy,
    _is.OrderByListBuilder<LiveOpsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LiveOps>(
      rows,
      orderBy: orderBy?.call(LiveOps.t),
      orderByList: orderByList?.call(LiveOps.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LiveOps].
  Future<LiveOps> deleteRow(
    _is.DatabaseSession session,
    LiveOps row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LiveOps>(
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
  Future<List<LiveOps>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LiveOpsTable> where,
    _is.OrderByBuilder<LiveOpsTable>? orderBy,
    _is.OrderByListBuilder<LiveOpsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LiveOps>(
      where: where(LiveOps.t),
      orderBy: orderBy?.call(LiveOps.t),
      orderByList: orderByList?.call(LiveOps.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LiveOpsTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LiveOps>(
      where: where?.call(LiveOps.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LiveOps] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LiveOpsTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LiveOps>(
      where: where(LiveOps.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
