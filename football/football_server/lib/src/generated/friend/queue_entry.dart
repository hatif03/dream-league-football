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

/// A player waiting for matchmaking to find an opponent.
abstract class QueueEntry
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
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
    _is.UuidValue? id,
    required String userId,
    required String mode,
    required String clientVersion,
    required int rating,
    DateTime? joinedAt,
    required DateTime lastPollAt,
    _is.UuidValue? lobbyId,
  }) = _QueueEntryImpl;

  factory QueueEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueueEntry(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      mode: jsonSerialization['mode'] as String,
      clientVersion: jsonSerialization['clientVersion'] as String,
      rating: jsonSerialization['rating'] as int,
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
      lastPollAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastPollAt'],
      ),
      lobbyId: jsonSerialization['lobbyId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['lobbyId']),
    );
  }

  static final t = QueueEntryTable();

  static const db = QueueEntryRepository._();

  @override
  _is.UuidValue? id;

  String userId;

  /// match | penalties
  String mode;

  String clientVersion;

  int rating;

  DateTime joinedAt;

  /// Updated while the player's page keeps asking; a silent entry is dropped.
  DateTime lastPollAt;

  /// Set when an opponent was found: the room both were seated in.
  _is.UuidValue? lobbyId;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [QueueEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  QueueEntry copyWith({
    _is.UuidValue? id,
    String? userId,
    String? mode,
    String? clientVersion,
    int? rating,
    DateTime? joinedAt,
    DateTime? lastPollAt,
    _is.UuidValue? lobbyId,
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

  static QueueEntryInclude include() {
    return QueueEntryInclude._();
  }

  static QueueEntryIncludeList includeList({
    _is.WhereExpressionBuilder<QueueEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QueueEntryTable>? orderBy,
    _is.OrderByListBuilder<QueueEntryTable>? orderByList,
    QueueEntryInclude? include,
  }) {
    return QueueEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QueueEntry.t),
      orderByList: orderByList?.call(QueueEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QueueEntryImpl extends QueueEntry {
  _QueueEntryImpl({
    _is.UuidValue? id,
    required String userId,
    required String mode,
    required String clientVersion,
    required int rating,
    DateTime? joinedAt,
    required DateTime lastPollAt,
    _is.UuidValue? lobbyId,
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
  @_is.useResult
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
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      mode: mode ?? this.mode,
      clientVersion: clientVersion ?? this.clientVersion,
      rating: rating ?? this.rating,
      joinedAt: joinedAt ?? this.joinedAt,
      lastPollAt: lastPollAt ?? this.lastPollAt,
      lobbyId: lobbyId is _is.UuidValue? ? lobbyId : this.lobbyId,
    );
  }
}

class QueueEntryUpdateTable extends _is.UpdateTable<QueueEntryTable> {
  QueueEntryUpdateTable(super.table);

  _is.ColumnValue<String, String> userId(String value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> mode(String value) => _is.ColumnValue(
    table.mode,
    value,
  );

  _is.ColumnValue<String, String> clientVersion(String value) =>
      _is.ColumnValue(
        table.clientVersion,
        value,
      );

  _is.ColumnValue<int, int> rating(int value) => _is.ColumnValue(
    table.rating,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> joinedAt(DateTime value) =>
      _is.ColumnValue(
        table.joinedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastPollAt(DateTime value) =>
      _is.ColumnValue(
        table.lastPollAt,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> lobbyId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.lobbyId,
        value,
      );
}

class QueueEntryTable extends _is.Table<_is.UuidValue?> {
  QueueEntryTable({super.tableRelation}) : super(tableName: 'queue_entry') {
    updateTable = QueueEntryUpdateTable(this);
    userId = _is.ColumnString(
      'userId',
      this,
    );
    mode = _is.ColumnString(
      'mode',
      this,
    );
    clientVersion = _is.ColumnString(
      'clientVersion',
      this,
    );
    rating = _is.ColumnInt(
      'rating',
      this,
    );
    joinedAt = _is.ColumnDateTime(
      'joinedAt',
      this,
    );
    lastPollAt = _is.ColumnDateTime(
      'lastPollAt',
      this,
    );
    lobbyId = _is.ColumnUuid(
      'lobbyId',
      this,
    );
  }

  late final QueueEntryUpdateTable updateTable;

  late final _is.ColumnString userId;

  /// match | penalties
  late final _is.ColumnString mode;

  late final _is.ColumnString clientVersion;

  late final _is.ColumnInt rating;

  late final _is.ColumnDateTime joinedAt;

  /// Updated while the player's page keeps asking; a silent entry is dropped.
  late final _is.ColumnDateTime lastPollAt;

  /// Set when an opponent was found: the room both were seated in.
  late final _is.ColumnUuid lobbyId;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    mode,
    clientVersion,
    rating,
    joinedAt,
    lastPollAt,
    lobbyId,
  ];
}

class QueueEntryInclude extends _is.IncludeObject {
  QueueEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => QueueEntry.t;
}

class QueueEntryIncludeList extends _is.IncludeList {
  QueueEntryIncludeList._({
    _is.WhereExpressionBuilder<QueueEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(QueueEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => QueueEntry.t;
}

class QueueEntryRepository {
  const QueueEntryRepository._();

  /// Returns a list of [QueueEntry]s matching the given query parameters.
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
  Future<List<QueueEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QueueEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QueueEntryTable>? orderBy,
    _is.OrderByListBuilder<QueueEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<QueueEntry>(
      where: where?.call(QueueEntry.t),
      orderBy: orderBy?.call(QueueEntry.t),
      orderByList: orderByList?.call(QueueEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [QueueEntry] matching the given query parameters.
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
  Future<QueueEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QueueEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<QueueEntryTable>? orderBy,
    _is.OrderByListBuilder<QueueEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<QueueEntry>(
      where: where?.call(QueueEntry.t),
      orderBy: orderBy?.call(QueueEntry.t),
      orderByList: orderByList?.call(QueueEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [QueueEntry] by its [id] or null if no such row exists.
  Future<QueueEntry?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<QueueEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [QueueEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [QueueEntry]s will have their `id` fields set.
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
  Future<List<QueueEntry>> insert(
    _is.DatabaseSession session,
    List<QueueEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<QueueEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [QueueEntry] and returns the inserted row.
  ///
  /// The returned [QueueEntry] will have its `id` field set.
  Future<QueueEntry> insertRow(
    _is.DatabaseSession session,
    QueueEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<QueueEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [QueueEntry]s in the list and returns the resulting rows.
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
  /// The returned [QueueEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QueueEntry>> upsert(
    _is.DatabaseSession session,
    List<QueueEntry> rows, {
    required _is.ColumnSelections<QueueEntryTable> conflictColumns,
    _is.ColumnSelections<QueueEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<QueueEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<QueueEntry>(
      rows,
      conflictColumns: conflictColumns(QueueEntry.t),
      updateColumns: updateColumns?.call(QueueEntry.t),
      updateWhere: updateWhere?.call(QueueEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [QueueEntry] and returns the resulting row.
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
  /// The returned [QueueEntry] will have its `id` field set.
  Future<QueueEntry?> upsertRow(
    _is.DatabaseSession session,
    QueueEntry row, {
    required _is.ColumnSelections<QueueEntryTable> conflictColumns,
    _is.ColumnSelections<QueueEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<QueueEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<QueueEntry>(
      row,
      conflictColumns: conflictColumns(QueueEntry.t),
      updateColumns: updateColumns?.call(QueueEntry.t),
      updateWhere: updateWhere?.call(QueueEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [QueueEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QueueEntry>> update(
    _is.DatabaseSession session,
    List<QueueEntry> rows, {
    _is.ColumnSelections<QueueEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<QueueEntry>(
      rows,
      columns: columns?.call(QueueEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [QueueEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<QueueEntry> updateRow(
    _is.DatabaseSession session,
    QueueEntry row, {
    _is.ColumnSelections<QueueEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<QueueEntry>(
      row,
      columns: columns?.call(QueueEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [QueueEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<QueueEntry?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<QueueEntryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<QueueEntry>(
      id,
      columnValues: columnValues(QueueEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [QueueEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QueueEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<QueueEntryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<QueueEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QueueEntryTable>? orderBy,
    _is.OrderByListBuilder<QueueEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<QueueEntry>(
      columnValues: columnValues(QueueEntry.t.updateTable),
      where: where(QueueEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QueueEntry.t),
      orderByList: orderByList?.call(QueueEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [QueueEntry]s in the list and returns the deleted rows.
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
  Future<List<QueueEntry>> delete(
    _is.DatabaseSession session,
    List<QueueEntry> rows, {
    _is.OrderByBuilder<QueueEntryTable>? orderBy,
    _is.OrderByListBuilder<QueueEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<QueueEntry>(
      rows,
      orderBy: orderBy?.call(QueueEntry.t),
      orderByList: orderByList?.call(QueueEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [QueueEntry].
  Future<QueueEntry> deleteRow(
    _is.DatabaseSession session,
    QueueEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<QueueEntry>(
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
  Future<List<QueueEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QueueEntryTable> where,
    _is.OrderByBuilder<QueueEntryTable>? orderBy,
    _is.OrderByListBuilder<QueueEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<QueueEntry>(
      where: where(QueueEntry.t),
      orderBy: orderBy?.call(QueueEntry.t),
      orderByList: orderByList?.call(QueueEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QueueEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<QueueEntry>(
      where: where?.call(QueueEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [QueueEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QueueEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<QueueEntry>(
      where: where(QueueEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
