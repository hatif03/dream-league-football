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

/// A report about a player, with the match it happened in.
abstract class PlayerReport
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PlayerReport._({
    this.id,
    required this.reporterId,
    required this.targetId,
    this.matchId,
    required this.reason,
    DateTime? createdAt,
    this.resolvedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PlayerReport({
    _is.UuidValue? id,
    required String reporterId,
    required String targetId,
    _is.UuidValue? matchId,
    required String reason,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) = _PlayerReportImpl;

  factory PlayerReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlayerReport(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      reporterId: jsonSerialization['reporterId'] as String,
      targetId: jsonSerialization['targetId'] as String,
      matchId: jsonSerialization['matchId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['matchId']),
      reason: jsonSerialization['reason'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
    );
  }

  static final t = PlayerReportTable();

  static const db = PlayerReportRepository._();

  @override
  _is.UuidValue? id;

  String reporterId;

  String targetId;

  _is.UuidValue? matchId;

  String reason;

  DateTime createdAt;

  DateTime? resolvedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PlayerReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlayerReport copyWith({
    _is.UuidValue? id,
    String? reporterId,
    String? targetId,
    _is.UuidValue? matchId,
    String? reason,
    DateTime? createdAt,
    DateTime? resolvedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlayerReport',
      if (id != null) 'id': id?.toJson(),
      'reporterId': reporterId,
      'targetId': targetId,
      if (matchId != null) 'matchId': matchId?.toJson(),
      'reason': reason,
      'createdAt': createdAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlayerReport',
      if (id != null) 'id': id?.toJson(),
      'reporterId': reporterId,
      'targetId': targetId,
      if (matchId != null) 'matchId': matchId?.toJson(),
      'reason': reason,
      'createdAt': createdAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  static PlayerReportInclude include() {
    return PlayerReportInclude._();
  }

  static PlayerReportIncludeList includeList({
    _is.WhereExpressionBuilder<PlayerReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlayerReportTable>? orderBy,
    _is.OrderByListBuilder<PlayerReportTable>? orderByList,
    PlayerReportInclude? include,
  }) {
    return PlayerReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlayerReport.t),
      orderByList: orderByList?.call(PlayerReport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlayerReportImpl extends PlayerReport {
  _PlayerReportImpl({
    _is.UuidValue? id,
    required String reporterId,
    required String targetId,
    _is.UuidValue? matchId,
    required String reason,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) : super._(
         id: id,
         reporterId: reporterId,
         targetId: targetId,
         matchId: matchId,
         reason: reason,
         createdAt: createdAt,
         resolvedAt: resolvedAt,
       );

  /// Returns a shallow copy of this [PlayerReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlayerReport copyWith({
    Object? id = _Undefined,
    String? reporterId,
    String? targetId,
    Object? matchId = _Undefined,
    String? reason,
    DateTime? createdAt,
    Object? resolvedAt = _Undefined,
  }) {
    return PlayerReport(
      id: id is _is.UuidValue? ? id : this.id,
      reporterId: reporterId ?? this.reporterId,
      targetId: targetId ?? this.targetId,
      matchId: matchId is _is.UuidValue? ? matchId : this.matchId,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
    );
  }
}

class PlayerReportUpdateTable extends _is.UpdateTable<PlayerReportTable> {
  PlayerReportUpdateTable(super.table);

  _is.ColumnValue<String, String> reporterId(String value) => _is.ColumnValue(
    table.reporterId,
    value,
  );

  _is.ColumnValue<String, String> targetId(String value) => _is.ColumnValue(
    table.targetId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> matchId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.matchId,
        value,
      );

  _is.ColumnValue<String, String> reason(String value) => _is.ColumnValue(
    table.reason,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _is.ColumnValue(
        table.resolvedAt,
        value,
      );
}

class PlayerReportTable extends _is.Table<_is.UuidValue?> {
  PlayerReportTable({super.tableRelation}) : super(tableName: 'player_report') {
    updateTable = PlayerReportUpdateTable(this);
    reporterId = _is.ColumnString(
      'reporterId',
      this,
    );
    targetId = _is.ColumnString(
      'targetId',
      this,
    );
    matchId = _is.ColumnUuid(
      'matchId',
      this,
    );
    reason = _is.ColumnString(
      'reason',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    resolvedAt = _is.ColumnDateTime(
      'resolvedAt',
      this,
    );
  }

  late final PlayerReportUpdateTable updateTable;

  late final _is.ColumnString reporterId;

  late final _is.ColumnString targetId;

  late final _is.ColumnUuid matchId;

  late final _is.ColumnString reason;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime resolvedAt;

  @override
  List<_is.Column> get columns => [
    id,
    reporterId,
    targetId,
    matchId,
    reason,
    createdAt,
    resolvedAt,
  ];
}

class PlayerReportInclude extends _is.IncludeObject {
  PlayerReportInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => PlayerReport.t;
}

class PlayerReportIncludeList extends _is.IncludeList {
  PlayerReportIncludeList._({
    _is.WhereExpressionBuilder<PlayerReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PlayerReport.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PlayerReport.t;
}

class PlayerReportRepository {
  const PlayerReportRepository._();

  /// Returns a list of [PlayerReport]s matching the given query parameters.
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
  Future<List<PlayerReport>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlayerReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlayerReportTable>? orderBy,
    _is.OrderByListBuilder<PlayerReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PlayerReport>(
      where: where?.call(PlayerReport.t),
      orderBy: orderBy?.call(PlayerReport.t),
      orderByList: orderByList?.call(PlayerReport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PlayerReport] matching the given query parameters.
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
  Future<PlayerReport?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlayerReportTable>? where,
    int? offset,
    _is.OrderByBuilder<PlayerReportTable>? orderBy,
    _is.OrderByListBuilder<PlayerReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PlayerReport>(
      where: where?.call(PlayerReport.t),
      orderBy: orderBy?.call(PlayerReport.t),
      orderByList: orderByList?.call(PlayerReport.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PlayerReport] by its [id] or null if no such row exists.
  Future<PlayerReport?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PlayerReport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PlayerReport]s in the list and returns the inserted rows.
  ///
  /// The returned [PlayerReport]s will have their `id` fields set.
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
  Future<List<PlayerReport>> insert(
    _is.DatabaseSession session,
    List<PlayerReport> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PlayerReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PlayerReport] and returns the inserted row.
  ///
  /// The returned [PlayerReport] will have its `id` field set.
  Future<PlayerReport> insertRow(
    _is.DatabaseSession session,
    PlayerReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PlayerReport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PlayerReport]s in the list and returns the resulting rows.
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
  /// The returned [PlayerReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlayerReport>> upsert(
    _is.DatabaseSession session,
    List<PlayerReport> rows, {
    required _is.ColumnSelections<PlayerReportTable> conflictColumns,
    _is.ColumnSelections<PlayerReportTable>? updateColumns,
    _is.WhereExpressionBuilder<PlayerReportTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PlayerReport>(
      rows,
      conflictColumns: conflictColumns(PlayerReport.t),
      updateColumns: updateColumns?.call(PlayerReport.t),
      updateWhere: updateWhere?.call(PlayerReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PlayerReport] and returns the resulting row.
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
  /// The returned [PlayerReport] will have its `id` field set.
  Future<PlayerReport?> upsertRow(
    _is.DatabaseSession session,
    PlayerReport row, {
    required _is.ColumnSelections<PlayerReportTable> conflictColumns,
    _is.ColumnSelections<PlayerReportTable>? updateColumns,
    _is.WhereExpressionBuilder<PlayerReportTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PlayerReport>(
      row,
      conflictColumns: conflictColumns(PlayerReport.t),
      updateColumns: updateColumns?.call(PlayerReport.t),
      updateWhere: updateWhere?.call(PlayerReport.t),
      transaction: transaction,
    );
  }

  /// Updates all [PlayerReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlayerReport>> update(
    _is.DatabaseSession session,
    List<PlayerReport> rows, {
    _is.ColumnSelections<PlayerReportTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PlayerReport>(
      rows,
      columns: columns?.call(PlayerReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PlayerReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PlayerReport> updateRow(
    _is.DatabaseSession session,
    PlayerReport row, {
    _is.ColumnSelections<PlayerReportTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PlayerReport>(
      row,
      columns: columns?.call(PlayerReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PlayerReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PlayerReport?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PlayerReportUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PlayerReport>(
      id,
      columnValues: columnValues(PlayerReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PlayerReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PlayerReport>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PlayerReportUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PlayerReportTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PlayerReportTable>? orderBy,
    _is.OrderByListBuilder<PlayerReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PlayerReport>(
      columnValues: columnValues(PlayerReport.t.updateTable),
      where: where(PlayerReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlayerReport.t),
      orderByList: orderByList?.call(PlayerReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PlayerReport]s in the list and returns the deleted rows.
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
  Future<List<PlayerReport>> delete(
    _is.DatabaseSession session,
    List<PlayerReport> rows, {
    _is.OrderByBuilder<PlayerReportTable>? orderBy,
    _is.OrderByListBuilder<PlayerReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PlayerReport>(
      rows,
      orderBy: orderBy?.call(PlayerReport.t),
      orderByList: orderByList?.call(PlayerReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PlayerReport].
  Future<PlayerReport> deleteRow(
    _is.DatabaseSession session,
    PlayerReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PlayerReport>(
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
  Future<List<PlayerReport>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PlayerReportTable> where,
    _is.OrderByBuilder<PlayerReportTable>? orderBy,
    _is.OrderByListBuilder<PlayerReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PlayerReport>(
      where: where(PlayerReport.t),
      orderBy: orderBy?.call(PlayerReport.t),
      orderByList: orderByList?.call(PlayerReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PlayerReportTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PlayerReport>(
      where: where?.call(PlayerReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PlayerReport] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PlayerReportTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PlayerReport>(
      where: where(PlayerReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
