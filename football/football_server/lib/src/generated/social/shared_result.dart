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

/// A result a player chose to share: the picture lives in cloud storage, this row backs the /r/<id> link.
abstract class SharedResult
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  SharedResult._({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SharedResult({
    _is.UuidValue? id,
    required String userId,
    required String title,
    required String description,
    required String imagePath,
    DateTime? createdAt,
  }) = _SharedResultImpl;

  factory SharedResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedResult(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      imagePath: jsonSerialization['imagePath'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = SharedResultTable();

  static const db = SharedResultRepository._();

  @override
  _is.UuidValue? id;

  String userId;

  String title;

  String description;

  /// Path inside the public cloud storage.
  String imagePath;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SharedResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SharedResult copyWith({
    _is.UuidValue? id,
    String? userId,
    String? title,
    String? description,
    String? imagePath,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedResult',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedResult',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'createdAt': createdAt.toJson(),
    };
  }

  static SharedResultInclude include() {
    return SharedResultInclude._();
  }

  static SharedResultIncludeList includeList({
    _is.WhereExpressionBuilder<SharedResultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SharedResultTable>? orderBy,
    _is.OrderByListBuilder<SharedResultTable>? orderByList,
    SharedResultInclude? include,
  }) {
    return SharedResultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedResult.t),
      orderByList: orderByList?.call(SharedResult.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedResultImpl extends SharedResult {
  _SharedResultImpl({
    _is.UuidValue? id,
    required String userId,
    required String title,
    required String description,
    required String imagePath,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         description: description,
         imagePath: imagePath,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SharedResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SharedResult copyWith({
    Object? id = _Undefined,
    String? userId,
    String? title,
    String? description,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return SharedResult(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SharedResultUpdateTable extends _is.UpdateTable<SharedResultTable> {
  SharedResultUpdateTable(super.table);

  _is.ColumnValue<String, String> userId(String value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> imagePath(String value) => _is.ColumnValue(
    table.imagePath,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class SharedResultTable extends _is.Table<_is.UuidValue?> {
  SharedResultTable({super.tableRelation}) : super(tableName: 'shared_result') {
    updateTable = SharedResultUpdateTable(this);
    userId = _is.ColumnString(
      'userId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    imagePath = _is.ColumnString(
      'imagePath',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final SharedResultUpdateTable updateTable;

  late final _is.ColumnString userId;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  /// Path inside the public cloud storage.
  late final _is.ColumnString imagePath;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    title,
    description,
    imagePath,
    createdAt,
  ];
}

class SharedResultInclude extends _is.IncludeObject {
  SharedResultInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => SharedResult.t;
}

class SharedResultIncludeList extends _is.IncludeList {
  SharedResultIncludeList._({
    _is.WhereExpressionBuilder<SharedResultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SharedResult.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => SharedResult.t;
}

class SharedResultRepository {
  const SharedResultRepository._();

  /// Returns a list of [SharedResult]s matching the given query parameters.
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
  Future<List<SharedResult>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SharedResultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SharedResultTable>? orderBy,
    _is.OrderByListBuilder<SharedResultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SharedResult>(
      where: where?.call(SharedResult.t),
      orderBy: orderBy?.call(SharedResult.t),
      orderByList: orderByList?.call(SharedResult.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SharedResult] matching the given query parameters.
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
  Future<SharedResult?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SharedResultTable>? where,
    int? offset,
    _is.OrderByBuilder<SharedResultTable>? orderBy,
    _is.OrderByListBuilder<SharedResultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SharedResult>(
      where: where?.call(SharedResult.t),
      orderBy: orderBy?.call(SharedResult.t),
      orderByList: orderByList?.call(SharedResult.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SharedResult] by its [id] or null if no such row exists.
  Future<SharedResult?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SharedResult>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SharedResult]s in the list and returns the inserted rows.
  ///
  /// The returned [SharedResult]s will have their `id` fields set.
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
  Future<List<SharedResult>> insert(
    _is.DatabaseSession session,
    List<SharedResult> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SharedResult>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SharedResult] and returns the inserted row.
  ///
  /// The returned [SharedResult] will have its `id` field set.
  Future<SharedResult> insertRow(
    _is.DatabaseSession session,
    SharedResult row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SharedResult>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SharedResult]s in the list and returns the resulting rows.
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
  /// The returned [SharedResult]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedResult>> upsert(
    _is.DatabaseSession session,
    List<SharedResult> rows, {
    required _is.ColumnSelections<SharedResultTable> conflictColumns,
    _is.ColumnSelections<SharedResultTable>? updateColumns,
    _is.WhereExpressionBuilder<SharedResultTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SharedResult>(
      rows,
      conflictColumns: conflictColumns(SharedResult.t),
      updateColumns: updateColumns?.call(SharedResult.t),
      updateWhere: updateWhere?.call(SharedResult.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SharedResult] and returns the resulting row.
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
  /// The returned [SharedResult] will have its `id` field set.
  Future<SharedResult?> upsertRow(
    _is.DatabaseSession session,
    SharedResult row, {
    required _is.ColumnSelections<SharedResultTable> conflictColumns,
    _is.ColumnSelections<SharedResultTable>? updateColumns,
    _is.WhereExpressionBuilder<SharedResultTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SharedResult>(
      row,
      conflictColumns: conflictColumns(SharedResult.t),
      updateColumns: updateColumns?.call(SharedResult.t),
      updateWhere: updateWhere?.call(SharedResult.t),
      transaction: transaction,
    );
  }

  /// Updates all [SharedResult]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedResult>> update(
    _is.DatabaseSession session,
    List<SharedResult> rows, {
    _is.ColumnSelections<SharedResultTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SharedResult>(
      rows,
      columns: columns?.call(SharedResult.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SharedResult]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SharedResult> updateRow(
    _is.DatabaseSession session,
    SharedResult row, {
    _is.ColumnSelections<SharedResultTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SharedResult>(
      row,
      columns: columns?.call(SharedResult.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SharedResult] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SharedResult?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<SharedResultUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SharedResult>(
      id,
      columnValues: columnValues(SharedResult.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SharedResult]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedResult>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SharedResultUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SharedResultTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SharedResultTable>? orderBy,
    _is.OrderByListBuilder<SharedResultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SharedResult>(
      columnValues: columnValues(SharedResult.t.updateTable),
      where: where(SharedResult.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedResult.t),
      orderByList: orderByList?.call(SharedResult.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SharedResult]s in the list and returns the deleted rows.
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
  Future<List<SharedResult>> delete(
    _is.DatabaseSession session,
    List<SharedResult> rows, {
    _is.OrderByBuilder<SharedResultTable>? orderBy,
    _is.OrderByListBuilder<SharedResultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SharedResult>(
      rows,
      orderBy: orderBy?.call(SharedResult.t),
      orderByList: orderByList?.call(SharedResult.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SharedResult].
  Future<SharedResult> deleteRow(
    _is.DatabaseSession session,
    SharedResult row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SharedResult>(
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
  Future<List<SharedResult>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SharedResultTable> where,
    _is.OrderByBuilder<SharedResultTable>? orderBy,
    _is.OrderByListBuilder<SharedResultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SharedResult>(
      where: where(SharedResult.t),
      orderBy: orderBy?.call(SharedResult.t),
      orderByList: orderByList?.call(SharedResult.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SharedResultTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SharedResult>(
      where: where?.call(SharedResult.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SharedResult] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SharedResultTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SharedResult>(
      where: where(SharedResult.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
