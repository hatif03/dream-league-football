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

/// A head-to-head match between two humans. The score is stored only when both
/// players sign the same claim.
abstract class FriendMatch
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  FriendMatch._({
    this.id,
    required this.lobbyId,
    this.hostUserId,
    this.guestUserId,
    required this.hostNation,
    required this.guestNation,
    required this.status,
    this.hostClaim,
    this.guestClaim,
    this.hostGoals,
    this.guestGoals,
    this.endReason,
    this.winnerUserId,
    this.leaverUserId,
    this.offer,
    this.answer,
    this.stats,
    this.transport,
    DateTime? startedAt,
    this.firstClaimAt,
    this.endedAt,
  }) : startedAt = startedAt ?? DateTime.now();

  factory FriendMatch({
    _is.UuidValue? id,
    required _is.UuidValue lobbyId,
    String? hostUserId,
    String? guestUserId,
    required String hostNation,
    required String guestNation,
    required String status,
    String? hostClaim,
    String? guestClaim,
    int? hostGoals,
    int? guestGoals,
    String? endReason,
    String? winnerUserId,
    String? leaverUserId,
    String? offer,
    String? answer,
    String? stats,
    String? transport,
    DateTime? startedAt,
    DateTime? firstClaimAt,
    DateTime? endedAt,
  }) = _FriendMatchImpl;

  factory FriendMatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return FriendMatch(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      lobbyId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['lobbyId'],
      ),
      hostUserId: jsonSerialization['hostUserId'] as String?,
      guestUserId: jsonSerialization['guestUserId'] as String?,
      hostNation: jsonSerialization['hostNation'] as String,
      guestNation: jsonSerialization['guestNation'] as String,
      status: jsonSerialization['status'] as String,
      hostClaim: jsonSerialization['hostClaim'] as String?,
      guestClaim: jsonSerialization['guestClaim'] as String?,
      hostGoals: jsonSerialization['hostGoals'] as int?,
      guestGoals: jsonSerialization['guestGoals'] as int?,
      endReason: jsonSerialization['endReason'] as String?,
      winnerUserId: jsonSerialization['winnerUserId'] as String?,
      leaverUserId: jsonSerialization['leaverUserId'] as String?,
      offer: jsonSerialization['offer'] as String?,
      answer: jsonSerialization['answer'] as String?,
      stats: jsonSerialization['stats'] as String?,
      transport: jsonSerialization['transport'] as String?,
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      firstClaimAt: jsonSerialization['firstClaimAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstClaimAt'],
            ),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
    );
  }

  static final t = FriendMatchTable();

  static const db = FriendMatchRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue lobbyId;

  /// The host's browser runs the simulation.
  String? hostUserId;

  String? guestUserId;

  String hostNation;

  String guestNation;

  /// live | finished | abandoned | void
  String status;

  /// Each player's signed claim, as JSON: hostGoals, guestGoals, reason, leaver.
  String? hostClaim;

  String? guestClaim;

  int? hostGoals;

  int? guestGoals;

  /// fulltime | abandoned | mismatch | timeout
  String? endReason;

  /// Empty on a draw, an abandon or a void match.
  String? winnerUserId;

  /// The player who left, for an abandoned match.
  String? leaverUserId;

  /// WebRTC handshake, cleared once the channel opens.
  String? offer;

  String? answer;

  /// End-of-match numbers as JSON, reported by the host (counted by their simulation, not signed by the guest).
  String? stats;

  /// direct | relay, reported by the peers once connected.
  String? transport;

  DateTime startedAt;

  DateTime? firstClaimAt;

  DateTime? endedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FriendMatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FriendMatch copyWith({
    _is.UuidValue? id,
    _is.UuidValue? lobbyId,
    String? hostUserId,
    String? guestUserId,
    String? hostNation,
    String? guestNation,
    String? status,
    String? hostClaim,
    String? guestClaim,
    int? hostGoals,
    int? guestGoals,
    String? endReason,
    String? winnerUserId,
    String? leaverUserId,
    String? offer,
    String? answer,
    String? stats,
    String? transport,
    DateTime? startedAt,
    DateTime? firstClaimAt,
    DateTime? endedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FriendMatch',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      if (hostUserId != null) 'hostUserId': hostUserId,
      if (guestUserId != null) 'guestUserId': guestUserId,
      'hostNation': hostNation,
      'guestNation': guestNation,
      'status': status,
      if (hostClaim != null) 'hostClaim': hostClaim,
      if (guestClaim != null) 'guestClaim': guestClaim,
      if (hostGoals != null) 'hostGoals': hostGoals,
      if (guestGoals != null) 'guestGoals': guestGoals,
      if (endReason != null) 'endReason': endReason,
      if (winnerUserId != null) 'winnerUserId': winnerUserId,
      if (leaverUserId != null) 'leaverUserId': leaverUserId,
      if (offer != null) 'offer': offer,
      if (answer != null) 'answer': answer,
      if (stats != null) 'stats': stats,
      if (transport != null) 'transport': transport,
      'startedAt': startedAt.toJson(),
      if (firstClaimAt != null) 'firstClaimAt': firstClaimAt?.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FriendMatch',
      if (id != null) 'id': id?.toJson(),
      'lobbyId': lobbyId.toJson(),
      if (hostUserId != null) 'hostUserId': hostUserId,
      if (guestUserId != null) 'guestUserId': guestUserId,
      'hostNation': hostNation,
      'guestNation': guestNation,
      'status': status,
      if (hostClaim != null) 'hostClaim': hostClaim,
      if (guestClaim != null) 'guestClaim': guestClaim,
      if (hostGoals != null) 'hostGoals': hostGoals,
      if (guestGoals != null) 'guestGoals': guestGoals,
      if (endReason != null) 'endReason': endReason,
      if (winnerUserId != null) 'winnerUserId': winnerUserId,
      if (leaverUserId != null) 'leaverUserId': leaverUserId,
      if (offer != null) 'offer': offer,
      if (answer != null) 'answer': answer,
      if (stats != null) 'stats': stats,
      if (transport != null) 'transport': transport,
      'startedAt': startedAt.toJson(),
      if (firstClaimAt != null) 'firstClaimAt': firstClaimAt?.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  static FriendMatchInclude include() {
    return FriendMatchInclude._();
  }

  static FriendMatchIncludeList includeList({
    _is.WhereExpressionBuilder<FriendMatchTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FriendMatchTable>? orderBy,
    _is.OrderByListBuilder<FriendMatchTable>? orderByList,
    FriendMatchInclude? include,
  }) {
    return FriendMatchIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FriendMatch.t),
      orderByList: orderByList?.call(FriendMatch.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FriendMatchImpl extends FriendMatch {
  _FriendMatchImpl({
    _is.UuidValue? id,
    required _is.UuidValue lobbyId,
    String? hostUserId,
    String? guestUserId,
    required String hostNation,
    required String guestNation,
    required String status,
    String? hostClaim,
    String? guestClaim,
    int? hostGoals,
    int? guestGoals,
    String? endReason,
    String? winnerUserId,
    String? leaverUserId,
    String? offer,
    String? answer,
    String? stats,
    String? transport,
    DateTime? startedAt,
    DateTime? firstClaimAt,
    DateTime? endedAt,
  }) : super._(
         id: id,
         lobbyId: lobbyId,
         hostUserId: hostUserId,
         guestUserId: guestUserId,
         hostNation: hostNation,
         guestNation: guestNation,
         status: status,
         hostClaim: hostClaim,
         guestClaim: guestClaim,
         hostGoals: hostGoals,
         guestGoals: guestGoals,
         endReason: endReason,
         winnerUserId: winnerUserId,
         leaverUserId: leaverUserId,
         offer: offer,
         answer: answer,
         stats: stats,
         transport: transport,
         startedAt: startedAt,
         firstClaimAt: firstClaimAt,
         endedAt: endedAt,
       );

  /// Returns a shallow copy of this [FriendMatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FriendMatch copyWith({
    Object? id = _Undefined,
    _is.UuidValue? lobbyId,
    Object? hostUserId = _Undefined,
    Object? guestUserId = _Undefined,
    String? hostNation,
    String? guestNation,
    String? status,
    Object? hostClaim = _Undefined,
    Object? guestClaim = _Undefined,
    Object? hostGoals = _Undefined,
    Object? guestGoals = _Undefined,
    Object? endReason = _Undefined,
    Object? winnerUserId = _Undefined,
    Object? leaverUserId = _Undefined,
    Object? offer = _Undefined,
    Object? answer = _Undefined,
    Object? stats = _Undefined,
    Object? transport = _Undefined,
    DateTime? startedAt,
    Object? firstClaimAt = _Undefined,
    Object? endedAt = _Undefined,
  }) {
    return FriendMatch(
      id: id is _is.UuidValue? ? id : this.id,
      lobbyId: lobbyId ?? this.lobbyId,
      hostUserId: hostUserId is String? ? hostUserId : this.hostUserId,
      guestUserId: guestUserId is String? ? guestUserId : this.guestUserId,
      hostNation: hostNation ?? this.hostNation,
      guestNation: guestNation ?? this.guestNation,
      status: status ?? this.status,
      hostClaim: hostClaim is String? ? hostClaim : this.hostClaim,
      guestClaim: guestClaim is String? ? guestClaim : this.guestClaim,
      hostGoals: hostGoals is int? ? hostGoals : this.hostGoals,
      guestGoals: guestGoals is int? ? guestGoals : this.guestGoals,
      endReason: endReason is String? ? endReason : this.endReason,
      winnerUserId: winnerUserId is String? ? winnerUserId : this.winnerUserId,
      leaverUserId: leaverUserId is String? ? leaverUserId : this.leaverUserId,
      offer: offer is String? ? offer : this.offer,
      answer: answer is String? ? answer : this.answer,
      stats: stats is String? ? stats : this.stats,
      transport: transport is String? ? transport : this.transport,
      startedAt: startedAt ?? this.startedAt,
      firstClaimAt: firstClaimAt is DateTime?
          ? firstClaimAt
          : this.firstClaimAt,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
    );
  }
}

class FriendMatchUpdateTable extends _is.UpdateTable<FriendMatchTable> {
  FriendMatchUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> lobbyId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.lobbyId,
        value,
      );

  _is.ColumnValue<String, String> hostUserId(String? value) => _is.ColumnValue(
    table.hostUserId,
    value,
  );

  _is.ColumnValue<String, String> guestUserId(String? value) => _is.ColumnValue(
    table.guestUserId,
    value,
  );

  _is.ColumnValue<String, String> hostNation(String value) => _is.ColumnValue(
    table.hostNation,
    value,
  );

  _is.ColumnValue<String, String> guestNation(String value) => _is.ColumnValue(
    table.guestNation,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> hostClaim(String? value) => _is.ColumnValue(
    table.hostClaim,
    value,
  );

  _is.ColumnValue<String, String> guestClaim(String? value) => _is.ColumnValue(
    table.guestClaim,
    value,
  );

  _is.ColumnValue<int, int> hostGoals(int? value) => _is.ColumnValue(
    table.hostGoals,
    value,
  );

  _is.ColumnValue<int, int> guestGoals(int? value) => _is.ColumnValue(
    table.guestGoals,
    value,
  );

  _is.ColumnValue<String, String> endReason(String? value) => _is.ColumnValue(
    table.endReason,
    value,
  );

  _is.ColumnValue<String, String> winnerUserId(String? value) =>
      _is.ColumnValue(
        table.winnerUserId,
        value,
      );

  _is.ColumnValue<String, String> leaverUserId(String? value) =>
      _is.ColumnValue(
        table.leaverUserId,
        value,
      );

  _is.ColumnValue<String, String> offer(String? value) => _is.ColumnValue(
    table.offer,
    value,
  );

  _is.ColumnValue<String, String> answer(String? value) => _is.ColumnValue(
    table.answer,
    value,
  );

  _is.ColumnValue<String, String> stats(String? value) => _is.ColumnValue(
    table.stats,
    value,
  );

  _is.ColumnValue<String, String> transport(String? value) => _is.ColumnValue(
    table.transport,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _is.ColumnValue(
        table.startedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> firstClaimAt(DateTime? value) =>
      _is.ColumnValue(
        table.firstClaimAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endedAt(DateTime? value) =>
      _is.ColumnValue(
        table.endedAt,
        value,
      );
}

class FriendMatchTable extends _is.Table<_is.UuidValue?> {
  FriendMatchTable({super.tableRelation}) : super(tableName: 'friend_match') {
    updateTable = FriendMatchUpdateTable(this);
    lobbyId = _is.ColumnUuid(
      'lobbyId',
      this,
    );
    hostUserId = _is.ColumnString(
      'hostUserId',
      this,
    );
    guestUserId = _is.ColumnString(
      'guestUserId',
      this,
    );
    hostNation = _is.ColumnString(
      'hostNation',
      this,
    );
    guestNation = _is.ColumnString(
      'guestNation',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    hostClaim = _is.ColumnString(
      'hostClaim',
      this,
    );
    guestClaim = _is.ColumnString(
      'guestClaim',
      this,
    );
    hostGoals = _is.ColumnInt(
      'hostGoals',
      this,
    );
    guestGoals = _is.ColumnInt(
      'guestGoals',
      this,
    );
    endReason = _is.ColumnString(
      'endReason',
      this,
    );
    winnerUserId = _is.ColumnString(
      'winnerUserId',
      this,
    );
    leaverUserId = _is.ColumnString(
      'leaverUserId',
      this,
    );
    offer = _is.ColumnString(
      'offer',
      this,
    );
    answer = _is.ColumnString(
      'answer',
      this,
    );
    stats = _is.ColumnString(
      'stats',
      this,
    );
    transport = _is.ColumnString(
      'transport',
      this,
    );
    startedAt = _is.ColumnDateTime(
      'startedAt',
      this,
    );
    firstClaimAt = _is.ColumnDateTime(
      'firstClaimAt',
      this,
    );
    endedAt = _is.ColumnDateTime(
      'endedAt',
      this,
    );
  }

  late final FriendMatchUpdateTable updateTable;

  late final _is.ColumnUuid lobbyId;

  /// The host's browser runs the simulation.
  late final _is.ColumnString hostUserId;

  late final _is.ColumnString guestUserId;

  late final _is.ColumnString hostNation;

  late final _is.ColumnString guestNation;

  /// live | finished | abandoned | void
  late final _is.ColumnString status;

  /// Each player's signed claim, as JSON: hostGoals, guestGoals, reason, leaver.
  late final _is.ColumnString hostClaim;

  late final _is.ColumnString guestClaim;

  late final _is.ColumnInt hostGoals;

  late final _is.ColumnInt guestGoals;

  /// fulltime | abandoned | mismatch | timeout
  late final _is.ColumnString endReason;

  /// Empty on a draw, an abandon or a void match.
  late final _is.ColumnString winnerUserId;

  /// The player who left, for an abandoned match.
  late final _is.ColumnString leaverUserId;

  /// WebRTC handshake, cleared once the channel opens.
  late final _is.ColumnString offer;

  late final _is.ColumnString answer;

  /// End-of-match numbers as JSON, reported by the host (counted by their simulation, not signed by the guest).
  late final _is.ColumnString stats;

  /// direct | relay, reported by the peers once connected.
  late final _is.ColumnString transport;

  late final _is.ColumnDateTime startedAt;

  late final _is.ColumnDateTime firstClaimAt;

  late final _is.ColumnDateTime endedAt;

  @override
  List<_is.Column> get columns => [
    id,
    lobbyId,
    hostUserId,
    guestUserId,
    hostNation,
    guestNation,
    status,
    hostClaim,
    guestClaim,
    hostGoals,
    guestGoals,
    endReason,
    winnerUserId,
    leaverUserId,
    offer,
    answer,
    stats,
    transport,
    startedAt,
    firstClaimAt,
    endedAt,
  ];
}

class FriendMatchInclude extends _is.IncludeObject {
  FriendMatchInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => FriendMatch.t;
}

class FriendMatchIncludeList extends _is.IncludeList {
  FriendMatchIncludeList._({
    _is.WhereExpressionBuilder<FriendMatchTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FriendMatch.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => FriendMatch.t;
}

class FriendMatchRepository {
  const FriendMatchRepository._();

  /// Returns a list of [FriendMatch]s matching the given query parameters.
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
  Future<List<FriendMatch>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FriendMatchTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FriendMatchTable>? orderBy,
    _is.OrderByListBuilder<FriendMatchTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FriendMatch>(
      where: where?.call(FriendMatch.t),
      orderBy: orderBy?.call(FriendMatch.t),
      orderByList: orderByList?.call(FriendMatch.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FriendMatch] matching the given query parameters.
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
  Future<FriendMatch?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FriendMatchTable>? where,
    int? offset,
    _is.OrderByBuilder<FriendMatchTable>? orderBy,
    _is.OrderByListBuilder<FriendMatchTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FriendMatch>(
      where: where?.call(FriendMatch.t),
      orderBy: orderBy?.call(FriendMatch.t),
      orderByList: orderByList?.call(FriendMatch.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FriendMatch] by its [id] or null if no such row exists.
  Future<FriendMatch?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FriendMatch>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FriendMatch]s in the list and returns the inserted rows.
  ///
  /// The returned [FriendMatch]s will have their `id` fields set.
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
  Future<List<FriendMatch>> insert(
    _is.DatabaseSession session,
    List<FriendMatch> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FriendMatch>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FriendMatch] and returns the inserted row.
  ///
  /// The returned [FriendMatch] will have its `id` field set.
  Future<FriendMatch> insertRow(
    _is.DatabaseSession session,
    FriendMatch row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FriendMatch>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FriendMatch]s in the list and returns the resulting rows.
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
  /// The returned [FriendMatch]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FriendMatch>> upsert(
    _is.DatabaseSession session,
    List<FriendMatch> rows, {
    required _is.ColumnSelections<FriendMatchTable> conflictColumns,
    _is.ColumnSelections<FriendMatchTable>? updateColumns,
    _is.WhereExpressionBuilder<FriendMatchTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FriendMatch>(
      rows,
      conflictColumns: conflictColumns(FriendMatch.t),
      updateColumns: updateColumns?.call(FriendMatch.t),
      updateWhere: updateWhere?.call(FriendMatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FriendMatch] and returns the resulting row.
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
  /// The returned [FriendMatch] will have its `id` field set.
  Future<FriendMatch?> upsertRow(
    _is.DatabaseSession session,
    FriendMatch row, {
    required _is.ColumnSelections<FriendMatchTable> conflictColumns,
    _is.ColumnSelections<FriendMatchTable>? updateColumns,
    _is.WhereExpressionBuilder<FriendMatchTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FriendMatch>(
      row,
      conflictColumns: conflictColumns(FriendMatch.t),
      updateColumns: updateColumns?.call(FriendMatch.t),
      updateWhere: updateWhere?.call(FriendMatch.t),
      transaction: transaction,
    );
  }

  /// Updates all [FriendMatch]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FriendMatch>> update(
    _is.DatabaseSession session,
    List<FriendMatch> rows, {
    _is.ColumnSelections<FriendMatchTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FriendMatch>(
      rows,
      columns: columns?.call(FriendMatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FriendMatch]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FriendMatch> updateRow(
    _is.DatabaseSession session,
    FriendMatch row, {
    _is.ColumnSelections<FriendMatchTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FriendMatch>(
      row,
      columns: columns?.call(FriendMatch.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FriendMatch] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FriendMatch?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<FriendMatchUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FriendMatch>(
      id,
      columnValues: columnValues(FriendMatch.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FriendMatch]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FriendMatch>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FriendMatchUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FriendMatchTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FriendMatchTable>? orderBy,
    _is.OrderByListBuilder<FriendMatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FriendMatch>(
      columnValues: columnValues(FriendMatch.t.updateTable),
      where: where(FriendMatch.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FriendMatch.t),
      orderByList: orderByList?.call(FriendMatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FriendMatch]s in the list and returns the deleted rows.
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
  Future<List<FriendMatch>> delete(
    _is.DatabaseSession session,
    List<FriendMatch> rows, {
    _is.OrderByBuilder<FriendMatchTable>? orderBy,
    _is.OrderByListBuilder<FriendMatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FriendMatch>(
      rows,
      orderBy: orderBy?.call(FriendMatch.t),
      orderByList: orderByList?.call(FriendMatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FriendMatch].
  Future<FriendMatch> deleteRow(
    _is.DatabaseSession session,
    FriendMatch row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FriendMatch>(
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
  Future<List<FriendMatch>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FriendMatchTable> where,
    _is.OrderByBuilder<FriendMatchTable>? orderBy,
    _is.OrderByListBuilder<FriendMatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FriendMatch>(
      where: where(FriendMatch.t),
      orderBy: orderBy?.call(FriendMatch.t),
      orderByList: orderByList?.call(FriendMatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FriendMatchTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FriendMatch>(
      where: where?.call(FriendMatch.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FriendMatch] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FriendMatchTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FriendMatch>(
      where: where(FriendMatch.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
