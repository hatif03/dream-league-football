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

/// One player blocking another: no invites, requests or shared rooms either way.
abstract class UserBlock
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  UserBlock._({
    this.id,
    required this.userId,
    required this.blockedUserId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserBlock({
    _is.UuidValue? id,
    required String userId,
    required String blockedUserId,
    DateTime? createdAt,
  }) = _UserBlockImpl;

  factory UserBlock.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserBlock(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] as String,
      blockedUserId: jsonSerialization['blockedUserId'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = UserBlockTable();

  static const db = UserBlockRepository._();

  @override
  _is.UuidValue? id;

  String userId;

  String blockedUserId;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserBlock]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserBlock copyWith({
    _is.UuidValue? id,
    String? userId,
    String? blockedUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserBlock',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'blockedUserId': blockedUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserBlock',
      if (id != null) 'id': id?.toJson(),
      'userId': userId,
      'blockedUserId': blockedUserId,
      'createdAt': createdAt.toJson(),
    };
  }

  static UserBlockInclude include() {
    return UserBlockInclude._();
  }

  static UserBlockIncludeList includeList({
    _is.WhereExpressionBuilder<UserBlockTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserBlockTable>? orderBy,
    _is.OrderByListBuilder<UserBlockTable>? orderByList,
    UserBlockInclude? include,
  }) {
    return UserBlockIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserBlock.t),
      orderByList: orderByList?.call(UserBlock.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserBlockImpl extends UserBlock {
  _UserBlockImpl({
    _is.UuidValue? id,
    required String userId,
    required String blockedUserId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         blockedUserId: blockedUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UserBlock]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserBlock copyWith({
    Object? id = _Undefined,
    String? userId,
    String? blockedUserId,
    DateTime? createdAt,
  }) {
    return UserBlock(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      blockedUserId: blockedUserId ?? this.blockedUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserBlockUpdateTable extends _is.UpdateTable<UserBlockTable> {
  UserBlockUpdateTable(super.table);

  _is.ColumnValue<String, String> userId(String value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> blockedUserId(String value) =>
      _is.ColumnValue(
        table.blockedUserId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class UserBlockTable extends _is.Table<_is.UuidValue?> {
  UserBlockTable({super.tableRelation}) : super(tableName: 'user_block') {
    updateTable = UserBlockUpdateTable(this);
    userId = _is.ColumnString(
      'userId',
      this,
    );
    blockedUserId = _is.ColumnString(
      'blockedUserId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final UserBlockUpdateTable updateTable;

  late final _is.ColumnString userId;

  late final _is.ColumnString blockedUserId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    blockedUserId,
    createdAt,
  ];
}

class UserBlockInclude extends _is.IncludeObject {
  UserBlockInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => UserBlock.t;
}

class UserBlockIncludeList extends _is.IncludeList {
  UserBlockIncludeList._({
    _is.WhereExpressionBuilder<UserBlockTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserBlock.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => UserBlock.t;
}

class UserBlockRepository {
  const UserBlockRepository._();

  /// Returns a list of [UserBlock]s matching the given query parameters.
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
  Future<List<UserBlock>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserBlockTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserBlockTable>? orderBy,
    _is.OrderByListBuilder<UserBlockTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserBlock>(
      where: where?.call(UserBlock.t),
      orderBy: orderBy?.call(UserBlock.t),
      orderByList: orderByList?.call(UserBlock.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserBlock] matching the given query parameters.
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
  Future<UserBlock?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserBlockTable>? where,
    int? offset,
    _is.OrderByBuilder<UserBlockTable>? orderBy,
    _is.OrderByListBuilder<UserBlockTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserBlock>(
      where: where?.call(UserBlock.t),
      orderBy: orderBy?.call(UserBlock.t),
      orderByList: orderByList?.call(UserBlock.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserBlock] by its [id] or null if no such row exists.
  Future<UserBlock?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserBlock>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserBlock]s in the list and returns the inserted rows.
  ///
  /// The returned [UserBlock]s will have their `id` fields set.
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
  Future<List<UserBlock>> insert(
    _is.DatabaseSession session,
    List<UserBlock> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserBlock>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserBlock] and returns the inserted row.
  ///
  /// The returned [UserBlock] will have its `id` field set.
  Future<UserBlock> insertRow(
    _is.DatabaseSession session,
    UserBlock row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserBlock>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserBlock]s in the list and returns the resulting rows.
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
  /// The returned [UserBlock]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserBlock>> upsert(
    _is.DatabaseSession session,
    List<UserBlock> rows, {
    required _is.ColumnSelections<UserBlockTable> conflictColumns,
    _is.ColumnSelections<UserBlockTable>? updateColumns,
    _is.WhereExpressionBuilder<UserBlockTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserBlock>(
      rows,
      conflictColumns: conflictColumns(UserBlock.t),
      updateColumns: updateColumns?.call(UserBlock.t),
      updateWhere: updateWhere?.call(UserBlock.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserBlock] and returns the resulting row.
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
  /// The returned [UserBlock] will have its `id` field set.
  Future<UserBlock?> upsertRow(
    _is.DatabaseSession session,
    UserBlock row, {
    required _is.ColumnSelections<UserBlockTable> conflictColumns,
    _is.ColumnSelections<UserBlockTable>? updateColumns,
    _is.WhereExpressionBuilder<UserBlockTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserBlock>(
      row,
      conflictColumns: conflictColumns(UserBlock.t),
      updateColumns: updateColumns?.call(UserBlock.t),
      updateWhere: updateWhere?.call(UserBlock.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserBlock]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserBlock>> update(
    _is.DatabaseSession session,
    List<UserBlock> rows, {
    _is.ColumnSelections<UserBlockTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserBlock>(
      rows,
      columns: columns?.call(UserBlock.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserBlock]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserBlock> updateRow(
    _is.DatabaseSession session,
    UserBlock row, {
    _is.ColumnSelections<UserBlockTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserBlock>(
      row,
      columns: columns?.call(UserBlock.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserBlock] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserBlock?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<UserBlockUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserBlock>(
      id,
      columnValues: columnValues(UserBlock.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserBlock]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserBlock>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserBlockUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserBlockTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserBlockTable>? orderBy,
    _is.OrderByListBuilder<UserBlockTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserBlock>(
      columnValues: columnValues(UserBlock.t.updateTable),
      where: where(UserBlock.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserBlock.t),
      orderByList: orderByList?.call(UserBlock.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserBlock]s in the list and returns the deleted rows.
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
  Future<List<UserBlock>> delete(
    _is.DatabaseSession session,
    List<UserBlock> rows, {
    _is.OrderByBuilder<UserBlockTable>? orderBy,
    _is.OrderByListBuilder<UserBlockTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserBlock>(
      rows,
      orderBy: orderBy?.call(UserBlock.t),
      orderByList: orderByList?.call(UserBlock.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserBlock].
  Future<UserBlock> deleteRow(
    _is.DatabaseSession session,
    UserBlock row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserBlock>(
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
  Future<List<UserBlock>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserBlockTable> where,
    _is.OrderByBuilder<UserBlockTable>? orderBy,
    _is.OrderByListBuilder<UserBlockTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserBlock>(
      where: where(UserBlock.t),
      orderBy: orderBy?.call(UserBlock.t),
      orderByList: orderByList?.call(UserBlock.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserBlockTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserBlock>(
      where: where?.call(UserBlock.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserBlock] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserBlockTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserBlock>(
      where: where(UserBlock.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
