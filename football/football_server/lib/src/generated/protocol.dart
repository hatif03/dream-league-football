/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:football_server/src/generated/friend/match_view.dart'
    as _ie6yuv0z;
import 'package:football_server/src/generated/social/chat_line.dart'
    as _iejvwr7c;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'friend/friend_match.dart' as _i61u4k1q;
import 'friend/lobby.dart' as _iy2evbc1;
import 'friend/lobby_view.dart' as _iwcao3ye;
import 'friend/match_view.dart' as _in465to7;
import 'friend/signal_view.dart' as _iwiyctoy;
import 'game_exception.dart' as _iva62vub;
import 'profile/user_profile.dart' as _ik2xsncp;
import 'social/admin_stats.dart' as _ih7dxm8c;
import 'social/audit_log.dart' as _i2419br0;
import 'social/chat_line.dart' as _ixke9pf1;
import 'social/friends_view.dart' as _isb39j3s;
import 'social/friendship.dart' as _i76eh3vl;
import 'social/head_to_head.dart' as _ioxid9pm;
import 'social/invite_view.dart' as _ibhxaxmh;
import 'social/live_ops.dart' as _i0ak7238;
import 'social/live_status.dart' as _inm7enqw;
import 'social/lobby_invite.dart' as _im6jgtvt;
import 'social/lobby_message.dart' as _ipshgsbn;
import 'social/person_view.dart' as _i2tinm30;
import 'social/player_report.dart' as _i7lceyce;
import 'social/record_view.dart' as _iaqb5f9o;
import 'social/user_block.dart' as _ib9qj8iy;
import 'tournament/standing_row.dart' as _ip1i4so6;
import 'tournament/tournament.dart' as _ihp9r9tf;
import 'tournament/tournament_fixture.dart' as _iz6ze9lg;
import 'tournament/tournament_view.dart' as _i8117dck;
export 'friend/friend_match.dart';
export 'friend/lobby.dart';
export 'friend/lobby_view.dart';
export 'friend/match_view.dart';
export 'friend/signal_view.dart';
export 'game_exception.dart';
export 'profile/user_profile.dart';
export 'social/admin_stats.dart';
export 'social/audit_log.dart';
export 'social/chat_line.dart';
export 'social/friends_view.dart';
export 'social/friendship.dart';
export 'social/head_to_head.dart';
export 'social/invite_view.dart';
export 'social/live_ops.dart';
export 'social/live_status.dart';
export 'social/lobby_invite.dart';
export 'social/lobby_message.dart';
export 'social/person_view.dart';
export 'social/player_report.dart';
export 'social/record_view.dart';
export 'social/user_block.dart';
export 'tournament/standing_row.dart';
export 'tournament/tournament.dart';
export 'tournament/tournament_fixture.dart';
export 'tournament/tournament_view.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'audit_log',
      dartName: 'AuditLog',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'actorId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'target',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'detail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'friend_match',
      dartName: 'FriendMatch',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'lobbyId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'hostUserId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'guestUserId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'hostNation',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'guestNation',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'hostClaim',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'guestClaim',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'hostGoals',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'guestGoals',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'endReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'winnerUserId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'leaverUserId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'offer',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'answer',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'stats',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'transport',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'startedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'firstClaimAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'endedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'friend_match_host_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'hostUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'friend_match_guest_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'guestUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'friendship',
      dartName: 'Friendship',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'requesterId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'addresseeId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'friendship_pair_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'requesterId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'addresseeId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'friendship_addressee_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'addresseeId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'live_ops',
      dartName: 'LiveOps',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'maintenance',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'message',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'lobby',
      dartName: 'Lobby',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'hostUserId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'guestUserId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'hostNation',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'guestNation',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'hostReady',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'guestReady',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'clientVersion',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'matchId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'rematchLobbyId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'lobby_code_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'lobby_host_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'hostUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'lobby_guest_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'guestUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'lobby_invite',
      dartName: 'LobbyInvite',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'lobbyId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'fromUserId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'toUserId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'lobby_invite_pair_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lobbyId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'toUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'lobby_invite_to_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'toUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'lobby_message',
      dartName: 'LobbyMessage',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'lobbyId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'text',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'lobby_message_lobby_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lobbyId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'player_report',
      dartName: 'PlayerReport',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'reporterId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'targetId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'matchId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'reason',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'resolvedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'tournament',
      dartName: 'Tournament',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nationId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'eliminatedIn',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'finishedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'tournament_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'tournament_fixture',
      dartName: 'TournamentFixture',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'tournamentId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'round',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'groupName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'matchday',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'kickoffUtc',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'homeNation',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'awayNation',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'venue',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'matchNo',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'homeScore',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'awayScore',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'homePens',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'awayPens',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'decidedBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'playedByUser',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'nonce',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'tournament_fixture_tournament_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tournamentId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_block',
      dartName: 'UserBlock',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'blockedUserId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'user_block_pair_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'blockedUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_profile',
      dartName: 'UserProfile',
      schema: 'public',
      module: 'football',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'displayNameLower',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'region',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'favouriteNation',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'bannedUntil',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'termsAcceptedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'lastSeenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'user_profile_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'user_profile_name_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'displayNameLower',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i61u4k1q.FriendMatch) {
      return _i61u4k1q.FriendMatch.fromJson(data) as T;
    }
    if (t == _iy2evbc1.Lobby) {
      return _iy2evbc1.Lobby.fromJson(data) as T;
    }
    if (t == _iwcao3ye.LobbyView) {
      return _iwcao3ye.LobbyView.fromJson(data) as T;
    }
    if (t == _in465to7.MatchView) {
      return _in465to7.MatchView.fromJson(data) as T;
    }
    if (t == _iwiyctoy.SignalView) {
      return _iwiyctoy.SignalView.fromJson(data) as T;
    }
    if (t == _iva62vub.GameException) {
      return _iva62vub.GameException.fromJson(data) as T;
    }
    if (t == _ik2xsncp.UserProfile) {
      return _ik2xsncp.UserProfile.fromJson(data) as T;
    }
    if (t == _ih7dxm8c.AdminStats) {
      return _ih7dxm8c.AdminStats.fromJson(data) as T;
    }
    if (t == _i2419br0.AuditLog) {
      return _i2419br0.AuditLog.fromJson(data) as T;
    }
    if (t == _ixke9pf1.ChatLine) {
      return _ixke9pf1.ChatLine.fromJson(data) as T;
    }
    if (t == _isb39j3s.FriendsView) {
      return _isb39j3s.FriendsView.fromJson(data) as T;
    }
    if (t == _i76eh3vl.Friendship) {
      return _i76eh3vl.Friendship.fromJson(data) as T;
    }
    if (t == _ioxid9pm.HeadToHead) {
      return _ioxid9pm.HeadToHead.fromJson(data) as T;
    }
    if (t == _ibhxaxmh.InviteView) {
      return _ibhxaxmh.InviteView.fromJson(data) as T;
    }
    if (t == _i0ak7238.LiveOps) {
      return _i0ak7238.LiveOps.fromJson(data) as T;
    }
    if (t == _inm7enqw.LiveStatus) {
      return _inm7enqw.LiveStatus.fromJson(data) as T;
    }
    if (t == _im6jgtvt.LobbyInvite) {
      return _im6jgtvt.LobbyInvite.fromJson(data) as T;
    }
    if (t == _ipshgsbn.LobbyMessage) {
      return _ipshgsbn.LobbyMessage.fromJson(data) as T;
    }
    if (t == _i2tinm30.PersonView) {
      return _i2tinm30.PersonView.fromJson(data) as T;
    }
    if (t == _i7lceyce.PlayerReport) {
      return _i7lceyce.PlayerReport.fromJson(data) as T;
    }
    if (t == _iaqb5f9o.RecordView) {
      return _iaqb5f9o.RecordView.fromJson(data) as T;
    }
    if (t == _ib9qj8iy.UserBlock) {
      return _ib9qj8iy.UserBlock.fromJson(data) as T;
    }
    if (t == _ip1i4so6.StandingRow) {
      return _ip1i4so6.StandingRow.fromJson(data) as T;
    }
    if (t == _ihp9r9tf.Tournament) {
      return _ihp9r9tf.Tournament.fromJson(data) as T;
    }
    if (t == _iz6ze9lg.TournamentFixture) {
      return _iz6ze9lg.TournamentFixture.fromJson(data) as T;
    }
    if (t == _i8117dck.TournamentView) {
      return _i8117dck.TournamentView.fromJson(data) as T;
    }
    if (t == _is.getType<_i61u4k1q.FriendMatch?>()) {
      return (data != null ? _i61u4k1q.FriendMatch.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iy2evbc1.Lobby?>()) {
      return (data != null ? _iy2evbc1.Lobby.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iwcao3ye.LobbyView?>()) {
      return (data != null ? _iwcao3ye.LobbyView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_in465to7.MatchView?>()) {
      return (data != null ? _in465to7.MatchView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iwiyctoy.SignalView?>()) {
      return (data != null ? _iwiyctoy.SignalView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iva62vub.GameException?>()) {
      return (data != null ? _iva62vub.GameException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ik2xsncp.UserProfile?>()) {
      return (data != null ? _ik2xsncp.UserProfile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ih7dxm8c.AdminStats?>()) {
      return (data != null ? _ih7dxm8c.AdminStats.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2419br0.AuditLog?>()) {
      return (data != null ? _i2419br0.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixke9pf1.ChatLine?>()) {
      return (data != null ? _ixke9pf1.ChatLine.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_isb39j3s.FriendsView?>()) {
      return (data != null ? _isb39j3s.FriendsView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i76eh3vl.Friendship?>()) {
      return (data != null ? _i76eh3vl.Friendship.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ioxid9pm.HeadToHead?>()) {
      return (data != null ? _ioxid9pm.HeadToHead.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ibhxaxmh.InviteView?>()) {
      return (data != null ? _ibhxaxmh.InviteView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0ak7238.LiveOps?>()) {
      return (data != null ? _i0ak7238.LiveOps.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_inm7enqw.LiveStatus?>()) {
      return (data != null ? _inm7enqw.LiveStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_im6jgtvt.LobbyInvite?>()) {
      return (data != null ? _im6jgtvt.LobbyInvite.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ipshgsbn.LobbyMessage?>()) {
      return (data != null ? _ipshgsbn.LobbyMessage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2tinm30.PersonView?>()) {
      return (data != null ? _i2tinm30.PersonView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7lceyce.PlayerReport?>()) {
      return (data != null ? _i7lceyce.PlayerReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iaqb5f9o.RecordView?>()) {
      return (data != null ? _iaqb5f9o.RecordView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ib9qj8iy.UserBlock?>()) {
      return (data != null ? _ib9qj8iy.UserBlock.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ip1i4so6.StandingRow?>()) {
      return (data != null ? _ip1i4so6.StandingRow.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihp9r9tf.Tournament?>()) {
      return (data != null ? _ihp9r9tf.Tournament.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iz6ze9lg.TournamentFixture?>()) {
      return (data != null ? _iz6ze9lg.TournamentFixture.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8117dck.TournamentView?>()) {
      return (data != null ? _i8117dck.TournamentView.fromJson(data) : null)
          as T;
    }
    if (t == List<_i2tinm30.PersonView>) {
      return (data as List)
              .map((e) => deserialize<_i2tinm30.PersonView>(e))
              .toList()
          as T;
    }
    if (t == List<_ibhxaxmh.InviteView>) {
      return (data as List)
              .map((e) => deserialize<_ibhxaxmh.InviteView>(e))
              .toList()
          as T;
    }
    if (t == List<_ioxid9pm.HeadToHead>) {
      return (data as List)
              .map((e) => deserialize<_ioxid9pm.HeadToHead>(e))
              .toList()
          as T;
    }
    if (t == List<_iz6ze9lg.TournamentFixture>) {
      return (data as List)
              .map((e) => deserialize<_iz6ze9lg.TournamentFixture>(e))
              .toList()
          as T;
    }
    if (t == List<_ip1i4so6.StandingRow>) {
      return (data as List)
              .map((e) => deserialize<_ip1i4so6.StandingRow>(e))
              .toList()
          as T;
    }
    if (t == List<_ie6yuv0z.MatchView>) {
      return (data as List)
              .map((e) => deserialize<_ie6yuv0z.MatchView>(e))
              .toList()
          as T;
    }
    if (t == List<_iejvwr7c.ChatLine>) {
      return (data as List)
              .map((e) => deserialize<_iejvwr7c.ChatLine>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i61u4k1q.FriendMatch => 'FriendMatch',
      _iy2evbc1.Lobby => 'Lobby',
      _iwcao3ye.LobbyView => 'LobbyView',
      _in465to7.MatchView => 'MatchView',
      _iwiyctoy.SignalView => 'SignalView',
      _iva62vub.GameException => 'GameException',
      _ik2xsncp.UserProfile => 'UserProfile',
      _ih7dxm8c.AdminStats => 'AdminStats',
      _i2419br0.AuditLog => 'AuditLog',
      _ixke9pf1.ChatLine => 'ChatLine',
      _isb39j3s.FriendsView => 'FriendsView',
      _i76eh3vl.Friendship => 'Friendship',
      _ioxid9pm.HeadToHead => 'HeadToHead',
      _ibhxaxmh.InviteView => 'InviteView',
      _i0ak7238.LiveOps => 'LiveOps',
      _inm7enqw.LiveStatus => 'LiveStatus',
      _im6jgtvt.LobbyInvite => 'LobbyInvite',
      _ipshgsbn.LobbyMessage => 'LobbyMessage',
      _i2tinm30.PersonView => 'PersonView',
      _i7lceyce.PlayerReport => 'PlayerReport',
      _iaqb5f9o.RecordView => 'RecordView',
      _ib9qj8iy.UserBlock => 'UserBlock',
      _ip1i4so6.StandingRow => 'StandingRow',
      _ihp9r9tf.Tournament => 'Tournament',
      _iz6ze9lg.TournamentFixture => 'TournamentFixture',
      _i8117dck.TournamentView => 'TournamentView',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('football.', '');
    }

    switch (data) {
      case _i61u4k1q.FriendMatch():
        return 'FriendMatch';
      case _iy2evbc1.Lobby():
        return 'Lobby';
      case _iwcao3ye.LobbyView():
        return 'LobbyView';
      case _in465to7.MatchView():
        return 'MatchView';
      case _iwiyctoy.SignalView():
        return 'SignalView';
      case _iva62vub.GameException():
        return 'GameException';
      case _ik2xsncp.UserProfile():
        return 'UserProfile';
      case _ih7dxm8c.AdminStats():
        return 'AdminStats';
      case _i2419br0.AuditLog():
        return 'AuditLog';
      case _ixke9pf1.ChatLine():
        return 'ChatLine';
      case _isb39j3s.FriendsView():
        return 'FriendsView';
      case _i76eh3vl.Friendship():
        return 'Friendship';
      case _ioxid9pm.HeadToHead():
        return 'HeadToHead';
      case _ibhxaxmh.InviteView():
        return 'InviteView';
      case _i0ak7238.LiveOps():
        return 'LiveOps';
      case _inm7enqw.LiveStatus():
        return 'LiveStatus';
      case _im6jgtvt.LobbyInvite():
        return 'LobbyInvite';
      case _ipshgsbn.LobbyMessage():
        return 'LobbyMessage';
      case _i2tinm30.PersonView():
        return 'PersonView';
      case _i7lceyce.PlayerReport():
        return 'PlayerReport';
      case _iaqb5f9o.RecordView():
        return 'RecordView';
      case _ib9qj8iy.UserBlock():
        return 'UserBlock';
      case _ip1i4so6.StandingRow():
        return 'StandingRow';
      case _ihp9r9tf.Tournament():
        return 'Tournament';
      case _iz6ze9lg.TournamentFixture():
        return 'TournamentFixture';
      case _i8117dck.TournamentView():
        return 'TournamentView';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'FriendMatch') {
      return deserialize<_i61u4k1q.FriendMatch>(data['data']);
    }
    if (dataClassName == 'Lobby') {
      return deserialize<_iy2evbc1.Lobby>(data['data']);
    }
    if (dataClassName == 'LobbyView') {
      return deserialize<_iwcao3ye.LobbyView>(data['data']);
    }
    if (dataClassName == 'MatchView') {
      return deserialize<_in465to7.MatchView>(data['data']);
    }
    if (dataClassName == 'SignalView') {
      return deserialize<_iwiyctoy.SignalView>(data['data']);
    }
    if (dataClassName == 'GameException') {
      return deserialize<_iva62vub.GameException>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_ik2xsncp.UserProfile>(data['data']);
    }
    if (dataClassName == 'AdminStats') {
      return deserialize<_ih7dxm8c.AdminStats>(data['data']);
    }
    if (dataClassName == 'AuditLog') {
      return deserialize<_i2419br0.AuditLog>(data['data']);
    }
    if (dataClassName == 'ChatLine') {
      return deserialize<_ixke9pf1.ChatLine>(data['data']);
    }
    if (dataClassName == 'FriendsView') {
      return deserialize<_isb39j3s.FriendsView>(data['data']);
    }
    if (dataClassName == 'Friendship') {
      return deserialize<_i76eh3vl.Friendship>(data['data']);
    }
    if (dataClassName == 'HeadToHead') {
      return deserialize<_ioxid9pm.HeadToHead>(data['data']);
    }
    if (dataClassName == 'InviteView') {
      return deserialize<_ibhxaxmh.InviteView>(data['data']);
    }
    if (dataClassName == 'LiveOps') {
      return deserialize<_i0ak7238.LiveOps>(data['data']);
    }
    if (dataClassName == 'LiveStatus') {
      return deserialize<_inm7enqw.LiveStatus>(data['data']);
    }
    if (dataClassName == 'LobbyInvite') {
      return deserialize<_im6jgtvt.LobbyInvite>(data['data']);
    }
    if (dataClassName == 'LobbyMessage') {
      return deserialize<_ipshgsbn.LobbyMessage>(data['data']);
    }
    if (dataClassName == 'PersonView') {
      return deserialize<_i2tinm30.PersonView>(data['data']);
    }
    if (dataClassName == 'PlayerReport') {
      return deserialize<_i7lceyce.PlayerReport>(data['data']);
    }
    if (dataClassName == 'RecordView') {
      return deserialize<_iaqb5f9o.RecordView>(data['data']);
    }
    if (dataClassName == 'UserBlock') {
      return deserialize<_ib9qj8iy.UserBlock>(data['data']);
    }
    if (dataClassName == 'StandingRow') {
      return deserialize<_ip1i4so6.StandingRow>(data['data']);
    }
    if (dataClassName == 'Tournament') {
      return deserialize<_ihp9r9tf.Tournament>(data['data']);
    }
    if (dataClassName == 'TournamentFixture') {
      return deserialize<_iz6ze9lg.TournamentFixture>(data['data']);
    }
    if (dataClassName == 'TournamentView') {
      return deserialize<_i8117dck.TournamentView>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('football', this);
    _iacs.Protocol().registerHostProtocol('football', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i61u4k1q.FriendMatch:
        return _i61u4k1q.FriendMatch.t;
      case _iy2evbc1.Lobby:
        return _iy2evbc1.Lobby.t;
      case _ik2xsncp.UserProfile:
        return _ik2xsncp.UserProfile.t;
      case _i2419br0.AuditLog:
        return _i2419br0.AuditLog.t;
      case _i76eh3vl.Friendship:
        return _i76eh3vl.Friendship.t;
      case _i0ak7238.LiveOps:
        return _i0ak7238.LiveOps.t;
      case _im6jgtvt.LobbyInvite:
        return _im6jgtvt.LobbyInvite.t;
      case _ipshgsbn.LobbyMessage:
        return _ipshgsbn.LobbyMessage.t;
      case _i7lceyce.PlayerReport:
        return _i7lceyce.PlayerReport.t;
      case _ib9qj8iy.UserBlock:
        return _ib9qj8iy.UserBlock.t;
      case _ihp9r9tf.Tournament:
        return _ihp9r9tf.Tournament.t;
      case _iz6ze9lg.TournamentFixture:
        return _iz6ze9lg.TournamentFixture.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'football';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
