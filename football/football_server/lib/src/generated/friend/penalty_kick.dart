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

/// One kick of a penalty duel. The server draws the result when both players have chosen.
abstract class PenaltyKick
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PenaltyKick._({
    this.id,
    required this.matchId,
    required this.seq,
    required this.shooterUserId,
    this.shooterZone,
    this.keeperZone,
    this.outcome,
    required this.deadline,
    this.resolvedAt,
  });

  factory PenaltyKick({
    _is.UuidValue? id,
    required _is.UuidValue matchId,
    required int seq,
    required String shooterUserId,
    int? shooterZone,
    int? keeperZone,
    String? outcome,
    required DateTime deadline,
    DateTime? resolvedAt,
  }) = _PenaltyKickImpl;

  factory PenaltyKick.fromJson(Map<String, dynamic> jsonSerialization) {
    return PenaltyKick(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      matchId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['matchId'],
      ),
      seq: jsonSerialization['seq'] as int,
      shooterUserId: jsonSerialization['shooterUserId'] as String,
      shooterZone: jsonSerialization['shooterZone'] as int?,
      keeperZone: jsonSerialization['keeperZone'] as int?,
      outcome: jsonSerialization['outcome'] as String?,
      deadline: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['deadline'],
      ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
    );
  }

  static final t = PenaltyKickTable();

  static const db = PenaltyKickRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue matchId;

  /// 0, 2, 4... the host shoots; 1, 3, 5... the guest shoots.
  int seq;

  String shooterUserId;

  /// 0-5: top left, top centre, top right, bottom left, bottom centre, bottom right.
  int? shooterZone;

  int? keeperZone;

  /// goal | saved | miss | post, set when the kick is resolved.
  String? outcome;

  /// Each player has until then to choose; whoever has not is picked for by the server.
  DateTime deadline;

  DateTime? resolvedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PenaltyKick]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PenaltyKick copyWith({
    _is.UuidValue? id,
    _is.UuidValue? matchId,
    int? seq,
    String? shooterUserId,
    int? shooterZone,
    int? keeperZone,
    String? outcome,
    DateTime? deadline,
    DateTime? resolvedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PenaltyKick',
      if (id != null) 'id': id?.toJson(),
      'matchId': matchId.toJson(),
      'seq': seq,
      'shooterUserId': shooterUserId,
      if (shooterZone != null) 'shooterZone': shooterZone,
      if (keeperZone != null) 'keeperZone': keeperZone,
      if (outcome != null) 'outcome': outcome,
      'deadline': deadline.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PenaltyKick',
      if (id != null) 'id': id?.toJson(),
      'matchId': matchId.toJson(),
      'seq': seq,
      'shooterUserId': shooterUserId,
      if (shooterZone != null) 'shooterZone': shooterZone,
      if (keeperZone != null) 'keeperZone': keeperZone,
      if (outcome != null) 'outcome': outcome,
      'deadline': deadline.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  static PenaltyKickInclude include() {
    return PenaltyKickInclude._();
  }

  static PenaltyKickIncludeList includeList({
    _is.WhereExpressionBuilder<PenaltyKickTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PenaltyKickTable>? orderBy,
    _is.OrderByListBuilder<PenaltyKickTable>? orderByList,
    PenaltyKickInclude? include,
  }) {
    return PenaltyKickIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PenaltyKick.t),
      orderByList: orderByList?.call(PenaltyKick.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PenaltyKickImpl extends PenaltyKick {
  _PenaltyKickImpl({
    _is.UuidValue? id,
    required _is.UuidValue matchId,
    required int seq,
    required String shooterUserId,
    int? shooterZone,
    int? keeperZone,
    String? outcome,
    required DateTime deadline,
    DateTime? resolvedAt,
  }) : super._(
         id: id,
         matchId: matchId,
         seq: seq,
         shooterUserId: shooterUserId,
         shooterZone: shooterZone,
         keeperZone: keeperZone,
         outcome: outcome,
         deadline: deadline,
         resolvedAt: resolvedAt,
       );

  /// Returns a shallow copy of this [PenaltyKick]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PenaltyKick copyWith({
    Object? id = _Undefined,
    _is.UuidValue? matchId,
    int? seq,
    String? shooterUserId,
    Object? shooterZone = _Undefined,
    Object? keeperZone = _Undefined,
    Object? outcome = _Undefined,
    DateTime? deadline,
    Object? resolvedAt = _Undefined,
  }) {
    return PenaltyKick(
      id: id is _is.UuidValue? ? id : this.id,
      matchId: matchId ?? this.matchId,
      seq: seq ?? this.seq,
      shooterUserId: shooterUserId ?? this.shooterUserId,
      shooterZone: shooterZone is int? ? shooterZone : this.shooterZone,
      keeperZone: keeperZone is int? ? keeperZone : this.keeperZone,
      outcome: outcome is String? ? outcome : this.outcome,
      deadline: deadline ?? this.deadline,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
    );
  }
}

class PenaltyKickUpdateTable extends _is.UpdateTable<PenaltyKickTable> {
  PenaltyKickUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> matchId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.matchId,
        value,
      );

  _is.ColumnValue<int, int> seq(int value) => _is.ColumnValue(
    table.seq,
    value,
  );

  _is.ColumnValue<String, String> shooterUserId(String value) =>
      _is.ColumnValue(
        table.shooterUserId,
        value,
      );

  _is.ColumnValue<int, int> shooterZone(int? value) => _is.ColumnValue(
    table.shooterZone,
    value,
  );

  _is.ColumnValue<int, int> keeperZone(int? value) => _is.ColumnValue(
    table.keeperZone,
    value,
  );

  _is.ColumnValue<String, String> outcome(String? value) => _is.ColumnValue(
    table.outcome,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> deadline(DateTime value) =>
      _is.ColumnValue(
        table.deadline,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _is.ColumnValue(
        table.resolvedAt,
        value,
      );
}

class PenaltyKickTable extends _is.Table<_is.UuidValue?> {
  PenaltyKickTable({super.tableRelation}) : super(tableName: 'penalty_kick') {
    updateTable = PenaltyKickUpdateTable(this);
    matchId = _is.ColumnUuid(
      'matchId',
      this,
    );
    seq = _is.ColumnInt(
      'seq',
      this,
    );
    shooterUserId = _is.ColumnString(
      'shooterUserId',
      this,
    );
    shooterZone = _is.ColumnInt(
      'shooterZone',
      this,
    );
    keeperZone = _is.ColumnInt(
      'keeperZone',
      this,
    );
    outcome = _is.ColumnString(
      'outcome',
      this,
    );
    deadline = _is.ColumnDateTime(
      'deadline',
      this,
    );
    resolvedAt = _is.ColumnDateTime(
      'resolvedAt',
      this,
    );
  }

  late final PenaltyKickUpdateTable updateTable;

  late final _is.ColumnUuid matchId;

  /// 0, 2, 4... the host shoots; 1, 3, 5... the guest shoots.
  late final _is.ColumnInt seq;

  late final _is.ColumnString shooterUserId;

  /// 0-5: top left, top centre, top right, bottom left, bottom centre, bottom right.
  late final _is.ColumnInt shooterZone;

  late final _is.ColumnInt keeperZone;

  /// goal | saved | miss | post, set when the kick is resolved.
  late final _is.ColumnString outcome;

  /// Each player has until then to choose; whoever has not is picked for by the server.
  late final _is.ColumnDateTime deadline;

  late final _is.ColumnDateTime resolvedAt;

  @override
  List<_is.Column> get columns => [
    id,
    matchId,
    seq,
    shooterUserId,
    shooterZone,
    keeperZone,
    outcome,
    deadline,
    resolvedAt,
  ];
}

class PenaltyKickInclude extends _is.IncludeObject {
  PenaltyKickInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => PenaltyKick.t;
}

class PenaltyKickIncludeList extends _is.IncludeList {
  PenaltyKickIncludeList._({
    _is.WhereExpressionBuilder<PenaltyKickTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PenaltyKick.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PenaltyKick.t;
}

class PenaltyKickRepository {
  const PenaltyKickRepository._();

  /// Returns a list of [PenaltyKick]s matching the given query parameters.
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
  Future<List<PenaltyKick>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PenaltyKickTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PenaltyKickTable>? orderBy,
    _is.OrderByListBuilder<PenaltyKickTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PenaltyKick>(
      where: where?.call(PenaltyKick.t),
      orderBy: orderBy?.call(PenaltyKick.t),
      orderByList: orderByList?.call(PenaltyKick.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PenaltyKick] matching the given query parameters.
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
  Future<PenaltyKick?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PenaltyKickTable>? where,
    int? offset,
    _is.OrderByBuilder<PenaltyKickTable>? orderBy,
    _is.OrderByListBuilder<PenaltyKickTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PenaltyKick>(
      where: where?.call(PenaltyKick.t),
      orderBy: orderBy?.call(PenaltyKick.t),
      orderByList: orderByList?.call(PenaltyKick.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PenaltyKick] by its [id] or null if no such row exists.
  Future<PenaltyKick?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PenaltyKick>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PenaltyKick]s in the list and returns the inserted rows.
  ///
  /// The returned [PenaltyKick]s will have their `id` fields set.
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
  Future<List<PenaltyKick>> insert(
    _is.DatabaseSession session,
    List<PenaltyKick> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PenaltyKick>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PenaltyKick] and returns the inserted row.
  ///
  /// The returned [PenaltyKick] will have its `id` field set.
  Future<PenaltyKick> insertRow(
    _is.DatabaseSession session,
    PenaltyKick row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PenaltyKick>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PenaltyKick]s in the list and returns the resulting rows.
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
  /// The returned [PenaltyKick]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PenaltyKick>> upsert(
    _is.DatabaseSession session,
    List<PenaltyKick> rows, {
    required _is.ColumnSelections<PenaltyKickTable> conflictColumns,
    _is.ColumnSelections<PenaltyKickTable>? updateColumns,
    _is.WhereExpressionBuilder<PenaltyKickTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PenaltyKick>(
      rows,
      conflictColumns: conflictColumns(PenaltyKick.t),
      updateColumns: updateColumns?.call(PenaltyKick.t),
      updateWhere: updateWhere?.call(PenaltyKick.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PenaltyKick] and returns the resulting row.
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
  /// The returned [PenaltyKick] will have its `id` field set.
  Future<PenaltyKick?> upsertRow(
    _is.DatabaseSession session,
    PenaltyKick row, {
    required _is.ColumnSelections<PenaltyKickTable> conflictColumns,
    _is.ColumnSelections<PenaltyKickTable>? updateColumns,
    _is.WhereExpressionBuilder<PenaltyKickTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PenaltyKick>(
      row,
      conflictColumns: conflictColumns(PenaltyKick.t),
      updateColumns: updateColumns?.call(PenaltyKick.t),
      updateWhere: updateWhere?.call(PenaltyKick.t),
      transaction: transaction,
    );
  }

  /// Updates all [PenaltyKick]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PenaltyKick>> update(
    _is.DatabaseSession session,
    List<PenaltyKick> rows, {
    _is.ColumnSelections<PenaltyKickTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PenaltyKick>(
      rows,
      columns: columns?.call(PenaltyKick.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PenaltyKick]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PenaltyKick> updateRow(
    _is.DatabaseSession session,
    PenaltyKick row, {
    _is.ColumnSelections<PenaltyKickTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PenaltyKick>(
      row,
      columns: columns?.call(PenaltyKick.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PenaltyKick] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PenaltyKick?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PenaltyKickUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PenaltyKick>(
      id,
      columnValues: columnValues(PenaltyKick.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PenaltyKick]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PenaltyKick>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PenaltyKickUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PenaltyKickTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PenaltyKickTable>? orderBy,
    _is.OrderByListBuilder<PenaltyKickTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PenaltyKick>(
      columnValues: columnValues(PenaltyKick.t.updateTable),
      where: where(PenaltyKick.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PenaltyKick.t),
      orderByList: orderByList?.call(PenaltyKick.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PenaltyKick]s in the list and returns the deleted rows.
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
  Future<List<PenaltyKick>> delete(
    _is.DatabaseSession session,
    List<PenaltyKick> rows, {
    _is.OrderByBuilder<PenaltyKickTable>? orderBy,
    _is.OrderByListBuilder<PenaltyKickTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PenaltyKick>(
      rows,
      orderBy: orderBy?.call(PenaltyKick.t),
      orderByList: orderByList?.call(PenaltyKick.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PenaltyKick].
  Future<PenaltyKick> deleteRow(
    _is.DatabaseSession session,
    PenaltyKick row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PenaltyKick>(
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
  Future<List<PenaltyKick>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PenaltyKickTable> where,
    _is.OrderByBuilder<PenaltyKickTable>? orderBy,
    _is.OrderByListBuilder<PenaltyKickTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PenaltyKick>(
      where: where(PenaltyKick.t),
      orderBy: orderBy?.call(PenaltyKick.t),
      orderByList: orderByList?.call(PenaltyKick.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PenaltyKickTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PenaltyKick>(
      where: where?.call(PenaltyKick.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PenaltyKick] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PenaltyKickTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PenaltyKick>(
      where: where(PenaltyKick.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
