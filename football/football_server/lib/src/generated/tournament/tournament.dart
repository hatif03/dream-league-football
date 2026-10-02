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

/// One solo World Cup run for a user.
abstract class Tournament
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Tournament._({
    this.id,
    required this.userId,
    required this.nationId,
    required this.status,
    this.eliminatedIn,
    DateTime? createdAt,
    this.finishedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Tournament({
    _is.UuidValue? id,
    required String userId,
    required String nationId,
    required String status,
    String? eliminatedIn,
    DateTime? createdAt,
    DateTime? finishedAt,
  }) = _TournamentImpl;

  factory Tournament.fromJson(Map<String, dynamic> jsonSerialization) {
    return Tournament(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      nationId: jsonSerialization['nationId'] as String,
      status: jsonSerialization['status'] as String,
      eliminatedIn: jsonSerialization['eliminatedIn'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
    );
  }

  static final t = TournamentTable();

  static const db = TournamentRepository._();

  @override
  _is.UuidValue? id;

  String userId;

  String nationId;

  /// group | r32 | r16 | qf | sf | final (the round being played) | eliminated | champion
  String status;

  /// Round the run ended in (e.g. "group"), when status is eliminated.
  String? eliminatedIn;

  DateTime createdAt;

  DateTime? finishedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Tournament]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Tournament copyWith({
    _is.UuidValue? id,
    String? userId,
    String? nationId,
    String? status,
    String? eliminatedIn,
    DateTime? createdAt,
    DateTime? finishedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Tournament',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'nationId': nationId,
      'status': status,
      if (eliminatedIn != null) 'eliminatedIn': eliminatedIn,
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Tournament',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'nationId': nationId,
      'status': status,
      if (eliminatedIn != null) 'eliminatedIn': eliminatedIn,
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  static TournamentInclude include() {
    return TournamentInclude._();
  }

  static TournamentIncludeList includeList({
    _is.WhereExpressionBuilder<TournamentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TournamentTable>? orderBy,
    _is.OrderByListBuilder<TournamentTable>? orderByList,
    TournamentInclude? include,
  }) {
    return TournamentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Tournament.t),
      orderByList: orderByList?.call(Tournament.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TournamentImpl extends Tournament {
  _TournamentImpl({
    _is.UuidValue? id,
    required String userId,
    required String nationId,
    required String status,
    String? eliminatedIn,
    DateTime? createdAt,
    DateTime? finishedAt,
  }) : super._(
         id: id,
         userId: userId,
         nationId: nationId,
         status: status,
         eliminatedIn: eliminatedIn,
         createdAt: createdAt,
         finishedAt: finishedAt,
       );

  /// Returns a shallow copy of this [Tournament]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Tournament copyWith({
    Object? id = _Undefined,
    String? userId,
    String? nationId,
    String? status,
    Object? eliminatedIn = _Undefined,
    DateTime? createdAt,
    Object? finishedAt = _Undefined,
  }) {
    return Tournament(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      nationId: nationId ?? this.nationId,
      status: status ?? this.status,
      eliminatedIn: eliminatedIn is String? ? eliminatedIn : this.eliminatedIn,
      createdAt: createdAt ?? this.createdAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
    );
  }
}

class TournamentUpdateTable extends _is.UpdateTable<TournamentTable> {
  TournamentUpdateTable(super.table);

  _is.ColumnValue<String, String> userId(String value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> nationId(String value) => _is.ColumnValue(
    table.nationId,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> eliminatedIn(String? value) =>
      _is.ColumnValue(
        table.eliminatedIn,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> finishedAt(DateTime? value) =>
      _is.ColumnValue(
        table.finishedAt,
        value,
      );
}

class TournamentTable extends _is.Table<_is.UuidValue?> {
  TournamentTable({super.tableRelation}) : super(tableName: 'tournament') {
    updateTable = TournamentUpdateTable(this);
    userId = _is.ColumnString(
      'userId',
      this,
    );
    nationId = _is.ColumnString(
      'nationId',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    eliminatedIn = _is.ColumnString(
      'eliminatedIn',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    finishedAt = _is.ColumnDateTime(
      'finishedAt',
      this,
    );
  }

  late final TournamentUpdateTable updateTable;

  late final _is.ColumnString userId;

  late final _is.ColumnString nationId;

  /// group | r32 | r16 | qf | sf | final (the round being played) | eliminated | champion
  late final _is.ColumnString status;

  /// Round the run ended in (e.g. "group"), when status is eliminated.
  late final _is.ColumnString eliminatedIn;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime finishedAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    nationId,
    status,
    eliminatedIn,
    createdAt,
    finishedAt,
  ];
}

class TournamentInclude extends _is.IncludeObject {
  TournamentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Tournament.t;
}

class TournamentIncludeList extends _is.IncludeList {
  TournamentIncludeList._({
    _is.WhereExpressionBuilder<TournamentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Tournament.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Tournament.t;
}

class TournamentRepository {
  const TournamentRepository._();

  /// Returns a list of [Tournament]s matching the given query parameters.
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
  Future<List<Tournament>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TournamentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TournamentTable>? orderBy,
    _is.OrderByListBuilder<TournamentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Tournament>(
      where: where?.call(Tournament.t),
      orderBy: orderBy?.call(Tournament.t),
      orderByList: orderByList?.call(Tournament.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Tournament] matching the given query parameters.
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
  Future<Tournament?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TournamentTable>? where,
    int? offset,
    _is.OrderByBuilder<TournamentTable>? orderBy,
    _is.OrderByListBuilder<TournamentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Tournament>(
      where: where?.call(Tournament.t),
      orderBy: orderBy?.call(Tournament.t),
      orderByList: orderByList?.call(Tournament.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Tournament] by its [id] or null if no such row exists.
  Future<Tournament?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Tournament>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Tournament]s in the list and returns the inserted rows.
  ///
  /// The returned [Tournament]s will have their `id` fields set.
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
  Future<List<Tournament>> insert(
    _is.DatabaseSession session,
    List<Tournament> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Tournament>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Tournament] and returns the inserted row.
  ///
  /// The returned [Tournament] will have its `id` field set.
  Future<Tournament> insertRow(
    _is.DatabaseSession session,
    Tournament row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Tournament>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Tournament]s in the list and returns the resulting rows.
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
  /// The returned [Tournament]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Tournament>> upsert(
    _is.DatabaseSession session,
    List<Tournament> rows, {
    required _is.ColumnSelections<TournamentTable> conflictColumns,
    _is.ColumnSelections<TournamentTable>? updateColumns,
    _is.WhereExpressionBuilder<TournamentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Tournament>(
      rows,
      conflictColumns: conflictColumns(Tournament.t),
      updateColumns: updateColumns?.call(Tournament.t),
      updateWhere: updateWhere?.call(Tournament.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Tournament] and returns the resulting row.
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
  /// The returned [Tournament] will have its `id` field set.
  Future<Tournament?> upsertRow(
    _is.DatabaseSession session,
    Tournament row, {
    required _is.ColumnSelections<TournamentTable> conflictColumns,
    _is.ColumnSelections<TournamentTable>? updateColumns,
    _is.WhereExpressionBuilder<TournamentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Tournament>(
      row,
      conflictColumns: conflictColumns(Tournament.t),
      updateColumns: updateColumns?.call(Tournament.t),
      updateWhere: updateWhere?.call(Tournament.t),
      transaction: transaction,
    );
  }

  /// Updates all [Tournament]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Tournament>> update(
    _is.DatabaseSession session,
    List<Tournament> rows, {
    _is.ColumnSelections<TournamentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Tournament>(
      rows,
      columns: columns?.call(Tournament.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Tournament]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Tournament> updateRow(
    _is.DatabaseSession session,
    Tournament row, {
    _is.ColumnSelections<TournamentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Tournament>(
      row,
      columns: columns?.call(Tournament.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Tournament] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Tournament?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TournamentUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Tournament>(
      id,
      columnValues: columnValues(Tournament.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Tournament]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Tournament>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TournamentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TournamentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TournamentTable>? orderBy,
    _is.OrderByListBuilder<TournamentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Tournament>(
      columnValues: columnValues(Tournament.t.updateTable),
      where: where(Tournament.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Tournament.t),
      orderByList: orderByList?.call(Tournament.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Tournament]s in the list and returns the deleted rows.
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
  Future<List<Tournament>> delete(
    _is.DatabaseSession session,
    List<Tournament> rows, {
    _is.OrderByBuilder<TournamentTable>? orderBy,
    _is.OrderByListBuilder<TournamentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Tournament>(
      rows,
      orderBy: orderBy?.call(Tournament.t),
      orderByList: orderByList?.call(Tournament.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Tournament].
  Future<Tournament> deleteRow(
    _is.DatabaseSession session,
    Tournament row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Tournament>(
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
  Future<List<Tournament>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TournamentTable> where,
    _is.OrderByBuilder<TournamentTable>? orderBy,
    _is.OrderByListBuilder<TournamentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Tournament>(
      where: where(Tournament.t),
      orderBy: orderBy?.call(Tournament.t),
      orderByList: orderByList?.call(Tournament.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TournamentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Tournament>(
      where: where?.call(Tournament.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Tournament] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TournamentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Tournament>(
      where: where(Tournament.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
