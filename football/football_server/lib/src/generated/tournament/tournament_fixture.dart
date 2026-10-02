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

/// One fixture inside a run. Scores stay null until it has been played or simulated.
abstract class TournamentFixture
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  TournamentFixture._({
    this.id,
    required this.tournamentId,
    required this.round,
    required this.groupName,
    required this.matchday,
    required this.kickoffUtc,
    required this.homeNation,
    required this.awayNation,
    required this.venue,
    this.matchNo,
    this.homeScore,
    this.awayScore,
    this.homePens,
    this.awayPens,
    this.decidedBy,
    required this.playedByUser,
    this.nonce,
  });

  factory TournamentFixture({
    _is.UuidValue? id,
    required _is.UuidValue tournamentId,
    required String round,
    required String groupName,
    required int matchday,
    required DateTime kickoffUtc,
    required String homeNation,
    required String awayNation,
    required String venue,
    int? matchNo,
    int? homeScore,
    int? awayScore,
    int? homePens,
    int? awayPens,
    String? decidedBy,
    required bool playedByUser,
    String? nonce,
  }) = _TournamentFixtureImpl;

  factory TournamentFixture.fromJson(Map<String, dynamic> jsonSerialization) {
    return TournamentFixture(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tournamentId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['tournamentId'],
      ),
      round: jsonSerialization['round'] as String,
      groupName: jsonSerialization['groupName'] as String,
      matchday: jsonSerialization['matchday'] as int,
      kickoffUtc: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['kickoffUtc'],
      ),
      homeNation: jsonSerialization['homeNation'] as String,
      awayNation: jsonSerialization['awayNation'] as String,
      venue: jsonSerialization['venue'] as String,
      matchNo: jsonSerialization['matchNo'] as int?,
      homeScore: jsonSerialization['homeScore'] as int?,
      awayScore: jsonSerialization['awayScore'] as int?,
      homePens: jsonSerialization['homePens'] as int?,
      awayPens: jsonSerialization['awayPens'] as int?,
      decidedBy: jsonSerialization['decidedBy'] as String?,
      playedByUser: _is.BoolJsonExtension.fromJson(
        jsonSerialization['playedByUser'],
      ),
      nonce: jsonSerialization['nonce'] as String?,
    );
  }

  static final t = TournamentFixtureTable();

  static const db = TournamentFixtureRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue tournamentId;

  /// group | r32 | r16 | qf | sf | final
  String round;

  String groupName;

  int matchday;

  DateTime kickoffUtc;

  String homeNation;

  String awayNation;

  String venue;

  /// FIFA match number (73-104) for knockout games, null in the group stage.
  int? matchNo;

  int? homeScore;

  int? awayScore;

  /// Shootout goals when a knockout game was level after extra time.
  int? homePens;

  int? awayPens;

  /// 90 | et | pens
  String? decidedBy;

  /// true when the user played it, false when the server simulated it.
  bool playedByUser;

  /// Client nonce of the saved result; makes the post idempotent.
  String? nonce;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [TournamentFixture]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TournamentFixture copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tournamentId,
    String? round,
    String? groupName,
    int? matchday,
    DateTime? kickoffUtc,
    String? homeNation,
    String? awayNation,
    String? venue,
    int? matchNo,
    int? homeScore,
    int? awayScore,
    int? homePens,
    int? awayPens,
    String? decidedBy,
    bool? playedByUser,
    String? nonce,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TournamentFixture',
      if (id != null) 'id': id?.toJson(),
      'tournamentId': tournamentId.toJson(),
      'round': round,
      'groupName': groupName,
      'matchday': matchday,
      'kickoffUtc': kickoffUtc.toJson(),
      'homeNation': homeNation,
      'awayNation': awayNation,
      'venue': venue,
      if (matchNo != null) 'matchNo': matchNo,
      if (homeScore != null) 'homeScore': homeScore,
      if (awayScore != null) 'awayScore': awayScore,
      if (homePens != null) 'homePens': homePens,
      if (awayPens != null) 'awayPens': awayPens,
      if (decidedBy != null) 'decidedBy': decidedBy,
      'playedByUser': playedByUser,
      if (nonce != null) 'nonce': nonce,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TournamentFixture',
      if (id != null) 'id': id?.toJson(),
      'tournamentId': tournamentId.toJson(),
      'round': round,
      'groupName': groupName,
      'matchday': matchday,
      'kickoffUtc': kickoffUtc.toJson(),
      'homeNation': homeNation,
      'awayNation': awayNation,
      'venue': venue,
      if (matchNo != null) 'matchNo': matchNo,
      if (homeScore != null) 'homeScore': homeScore,
      if (awayScore != null) 'awayScore': awayScore,
      if (homePens != null) 'homePens': homePens,
      if (awayPens != null) 'awayPens': awayPens,
      if (decidedBy != null) 'decidedBy': decidedBy,
      'playedByUser': playedByUser,
      if (nonce != null) 'nonce': nonce,
    };
  }

  static TournamentFixtureInclude include() {
    return TournamentFixtureInclude._();
  }

  static TournamentFixtureIncludeList includeList({
    _is.WhereExpressionBuilder<TournamentFixtureTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TournamentFixtureTable>? orderBy,
    _is.OrderByListBuilder<TournamentFixtureTable>? orderByList,
    TournamentFixtureInclude? include,
  }) {
    return TournamentFixtureIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TournamentFixture.t),
      orderByList: orderByList?.call(TournamentFixture.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TournamentFixtureImpl extends TournamentFixture {
  _TournamentFixtureImpl({
    _is.UuidValue? id,
    required _is.UuidValue tournamentId,
    required String round,
    required String groupName,
    required int matchday,
    required DateTime kickoffUtc,
    required String homeNation,
    required String awayNation,
    required String venue,
    int? matchNo,
    int? homeScore,
    int? awayScore,
    int? homePens,
    int? awayPens,
    String? decidedBy,
    required bool playedByUser,
    String? nonce,
  }) : super._(
         id: id,
         tournamentId: tournamentId,
         round: round,
         groupName: groupName,
         matchday: matchday,
         kickoffUtc: kickoffUtc,
         homeNation: homeNation,
         awayNation: awayNation,
         venue: venue,
         matchNo: matchNo,
         homeScore: homeScore,
         awayScore: awayScore,
         homePens: homePens,
         awayPens: awayPens,
         decidedBy: decidedBy,
         playedByUser: playedByUser,
         nonce: nonce,
       );

  /// Returns a shallow copy of this [TournamentFixture]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TournamentFixture copyWith({
    Object? id = _Undefined,
    _is.UuidValue? tournamentId,
    String? round,
    String? groupName,
    int? matchday,
    DateTime? kickoffUtc,
    String? homeNation,
    String? awayNation,
    String? venue,
    Object? matchNo = _Undefined,
    Object? homeScore = _Undefined,
    Object? awayScore = _Undefined,
    Object? homePens = _Undefined,
    Object? awayPens = _Undefined,
    Object? decidedBy = _Undefined,
    bool? playedByUser,
    Object? nonce = _Undefined,
  }) {
    return TournamentFixture(
      id: id is _is.UuidValue? ? id : this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      round: round ?? this.round,
      groupName: groupName ?? this.groupName,
      matchday: matchday ?? this.matchday,
      kickoffUtc: kickoffUtc ?? this.kickoffUtc,
      homeNation: homeNation ?? this.homeNation,
      awayNation: awayNation ?? this.awayNation,
      venue: venue ?? this.venue,
      matchNo: matchNo is int? ? matchNo : this.matchNo,
      homeScore: homeScore is int? ? homeScore : this.homeScore,
      awayScore: awayScore is int? ? awayScore : this.awayScore,
      homePens: homePens is int? ? homePens : this.homePens,
      awayPens: awayPens is int? ? awayPens : this.awayPens,
      decidedBy: decidedBy is String? ? decidedBy : this.decidedBy,
      playedByUser: playedByUser ?? this.playedByUser,
      nonce: nonce is String? ? nonce : this.nonce,
    );
  }
}

class TournamentFixtureUpdateTable
    extends _is.UpdateTable<TournamentFixtureTable> {
  TournamentFixtureUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tournamentId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.tournamentId,
    value,
  );

  _is.ColumnValue<String, String> round(String value) => _is.ColumnValue(
    table.round,
    value,
  );

  _is.ColumnValue<String, String> groupName(String value) => _is.ColumnValue(
    table.groupName,
    value,
  );

  _is.ColumnValue<int, int> matchday(int value) => _is.ColumnValue(
    table.matchday,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> kickoffUtc(DateTime value) =>
      _is.ColumnValue(
        table.kickoffUtc,
        value,
      );

  _is.ColumnValue<String, String> homeNation(String value) => _is.ColumnValue(
    table.homeNation,
    value,
  );

  _is.ColumnValue<String, String> awayNation(String value) => _is.ColumnValue(
    table.awayNation,
    value,
  );

  _is.ColumnValue<String, String> venue(String value) => _is.ColumnValue(
    table.venue,
    value,
  );

  _is.ColumnValue<int, int> matchNo(int? value) => _is.ColumnValue(
    table.matchNo,
    value,
  );

  _is.ColumnValue<int, int> homeScore(int? value) => _is.ColumnValue(
    table.homeScore,
    value,
  );

  _is.ColumnValue<int, int> awayScore(int? value) => _is.ColumnValue(
    table.awayScore,
    value,
  );

  _is.ColumnValue<int, int> homePens(int? value) => _is.ColumnValue(
    table.homePens,
    value,
  );

  _is.ColumnValue<int, int> awayPens(int? value) => _is.ColumnValue(
    table.awayPens,
    value,
  );

  _is.ColumnValue<String, String> decidedBy(String? value) => _is.ColumnValue(
    table.decidedBy,
    value,
  );

  _is.ColumnValue<bool, bool> playedByUser(bool value) => _is.ColumnValue(
    table.playedByUser,
    value,
  );

  _is.ColumnValue<String, String> nonce(String? value) => _is.ColumnValue(
    table.nonce,
    value,
  );
}

class TournamentFixtureTable extends _is.Table<_is.UuidValue?> {
  TournamentFixtureTable({super.tableRelation})
    : super(tableName: 'tournament_fixture') {
    updateTable = TournamentFixtureUpdateTable(this);
    tournamentId = _is.ColumnUuid(
      'tournamentId',
      this,
    );
    round = _is.ColumnString(
      'round',
      this,
    );
    groupName = _is.ColumnString(
      'groupName',
      this,
    );
    matchday = _is.ColumnInt(
      'matchday',
      this,
    );
    kickoffUtc = _is.ColumnDateTime(
      'kickoffUtc',
      this,
    );
    homeNation = _is.ColumnString(
      'homeNation',
      this,
    );
    awayNation = _is.ColumnString(
      'awayNation',
      this,
    );
    venue = _is.ColumnString(
      'venue',
      this,
    );
    matchNo = _is.ColumnInt(
      'matchNo',
      this,
    );
    homeScore = _is.ColumnInt(
      'homeScore',
      this,
    );
    awayScore = _is.ColumnInt(
      'awayScore',
      this,
    );
    homePens = _is.ColumnInt(
      'homePens',
      this,
    );
    awayPens = _is.ColumnInt(
      'awayPens',
      this,
    );
    decidedBy = _is.ColumnString(
      'decidedBy',
      this,
    );
    playedByUser = _is.ColumnBool(
      'playedByUser',
      this,
    );
    nonce = _is.ColumnString(
      'nonce',
      this,
    );
  }

  late final TournamentFixtureUpdateTable updateTable;

  late final _is.ColumnUuid tournamentId;

  /// group | r32 | r16 | qf | sf | final
  late final _is.ColumnString round;

  late final _is.ColumnString groupName;

  late final _is.ColumnInt matchday;

  late final _is.ColumnDateTime kickoffUtc;

  late final _is.ColumnString homeNation;

  late final _is.ColumnString awayNation;

  late final _is.ColumnString venue;

  /// FIFA match number (73-104) for knockout games, null in the group stage.
  late final _is.ColumnInt matchNo;

  late final _is.ColumnInt homeScore;

  late final _is.ColumnInt awayScore;

  /// Shootout goals when a knockout game was level after extra time.
  late final _is.ColumnInt homePens;

  late final _is.ColumnInt awayPens;

  /// 90 | et | pens
  late final _is.ColumnString decidedBy;

  /// true when the user played it, false when the server simulated it.
  late final _is.ColumnBool playedByUser;

  /// Client nonce of the saved result; makes the post idempotent.
  late final _is.ColumnString nonce;

  @override
  List<_is.Column> get columns => [
    id,
    tournamentId,
    round,
    groupName,
    matchday,
    kickoffUtc,
    homeNation,
    awayNation,
    venue,
    matchNo,
    homeScore,
    awayScore,
    homePens,
    awayPens,
    decidedBy,
    playedByUser,
    nonce,
  ];
}

class TournamentFixtureInclude extends _is.IncludeObject {
  TournamentFixtureInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => TournamentFixture.t;
}

class TournamentFixtureIncludeList extends _is.IncludeList {
  TournamentFixtureIncludeList._({
    _is.WhereExpressionBuilder<TournamentFixtureTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TournamentFixture.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => TournamentFixture.t;
}

class TournamentFixtureRepository {
  const TournamentFixtureRepository._();

  /// Returns a list of [TournamentFixture]s matching the given query parameters.
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
  Future<List<TournamentFixture>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TournamentFixtureTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TournamentFixtureTable>? orderBy,
    _is.OrderByListBuilder<TournamentFixtureTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TournamentFixture>(
      where: where?.call(TournamentFixture.t),
      orderBy: orderBy?.call(TournamentFixture.t),
      orderByList: orderByList?.call(TournamentFixture.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TournamentFixture] matching the given query parameters.
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
  Future<TournamentFixture?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TournamentFixtureTable>? where,
    int? offset,
    _is.OrderByBuilder<TournamentFixtureTable>? orderBy,
    _is.OrderByListBuilder<TournamentFixtureTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TournamentFixture>(
      where: where?.call(TournamentFixture.t),
      orderBy: orderBy?.call(TournamentFixture.t),
      orderByList: orderByList?.call(TournamentFixture.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TournamentFixture] by its [id] or null if no such row exists.
  Future<TournamentFixture?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TournamentFixture>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TournamentFixture]s in the list and returns the inserted rows.
  ///
  /// The returned [TournamentFixture]s will have their `id` fields set.
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
  Future<List<TournamentFixture>> insert(
    _is.DatabaseSession session,
    List<TournamentFixture> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TournamentFixture>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TournamentFixture] and returns the inserted row.
  ///
  /// The returned [TournamentFixture] will have its `id` field set.
  Future<TournamentFixture> insertRow(
    _is.DatabaseSession session,
    TournamentFixture row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TournamentFixture>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TournamentFixture]s in the list and returns the resulting rows.
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
  /// The returned [TournamentFixture]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TournamentFixture>> upsert(
    _is.DatabaseSession session,
    List<TournamentFixture> rows, {
    required _is.ColumnSelections<TournamentFixtureTable> conflictColumns,
    _is.ColumnSelections<TournamentFixtureTable>? updateColumns,
    _is.WhereExpressionBuilder<TournamentFixtureTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TournamentFixture>(
      rows,
      conflictColumns: conflictColumns(TournamentFixture.t),
      updateColumns: updateColumns?.call(TournamentFixture.t),
      updateWhere: updateWhere?.call(TournamentFixture.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TournamentFixture] and returns the resulting row.
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
  /// The returned [TournamentFixture] will have its `id` field set.
  Future<TournamentFixture?> upsertRow(
    _is.DatabaseSession session,
    TournamentFixture row, {
    required _is.ColumnSelections<TournamentFixtureTable> conflictColumns,
    _is.ColumnSelections<TournamentFixtureTable>? updateColumns,
    _is.WhereExpressionBuilder<TournamentFixtureTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TournamentFixture>(
      row,
      conflictColumns: conflictColumns(TournamentFixture.t),
      updateColumns: updateColumns?.call(TournamentFixture.t),
      updateWhere: updateWhere?.call(TournamentFixture.t),
      transaction: transaction,
    );
  }

  /// Updates all [TournamentFixture]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TournamentFixture>> update(
    _is.DatabaseSession session,
    List<TournamentFixture> rows, {
    _is.ColumnSelections<TournamentFixtureTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TournamentFixture>(
      rows,
      columns: columns?.call(TournamentFixture.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TournamentFixture]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TournamentFixture> updateRow(
    _is.DatabaseSession session,
    TournamentFixture row, {
    _is.ColumnSelections<TournamentFixtureTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TournamentFixture>(
      row,
      columns: columns?.call(TournamentFixture.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TournamentFixture] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TournamentFixture?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TournamentFixtureUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TournamentFixture>(
      id,
      columnValues: columnValues(TournamentFixture.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TournamentFixture]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TournamentFixture>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TournamentFixtureUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TournamentFixtureTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TournamentFixtureTable>? orderBy,
    _is.OrderByListBuilder<TournamentFixtureTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TournamentFixture>(
      columnValues: columnValues(TournamentFixture.t.updateTable),
      where: where(TournamentFixture.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TournamentFixture.t),
      orderByList: orderByList?.call(TournamentFixture.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TournamentFixture]s in the list and returns the deleted rows.
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
  Future<List<TournamentFixture>> delete(
    _is.DatabaseSession session,
    List<TournamentFixture> rows, {
    _is.OrderByBuilder<TournamentFixtureTable>? orderBy,
    _is.OrderByListBuilder<TournamentFixtureTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TournamentFixture>(
      rows,
      orderBy: orderBy?.call(TournamentFixture.t),
      orderByList: orderByList?.call(TournamentFixture.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TournamentFixture].
  Future<TournamentFixture> deleteRow(
    _is.DatabaseSession session,
    TournamentFixture row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TournamentFixture>(
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
  Future<List<TournamentFixture>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TournamentFixtureTable> where,
    _is.OrderByBuilder<TournamentFixtureTable>? orderBy,
    _is.OrderByListBuilder<TournamentFixtureTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TournamentFixture>(
      where: where(TournamentFixture.t),
      orderBy: orderBy?.call(TournamentFixture.t),
      orderByList: orderByList?.call(TournamentFixture.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TournamentFixtureTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TournamentFixture>(
      where: where?.call(TournamentFixture.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TournamentFixture] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TournamentFixtureTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TournamentFixture>(
      where: where(TournamentFixture.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
