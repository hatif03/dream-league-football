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
import 'package:football_client/src/protocol/friend/match_view.dart'
    as _i4p1u5ur;
import 'package:football_client/src/protocol/rankings/achievement_view.dart'
    as _iqx1bsph;
import 'package:football_client/src/protocol/social/chat_line.dart'
    as _iy4xom0n;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'friend/duel_view.dart' as _ie4eb5hy;
import 'friend/friend_match.dart' as _i61u4k1q;
import 'friend/kick_due.dart' as _ikj0u1ic;
import 'friend/kick_view.dart' as _i9hpe2st;
import 'friend/lobby.dart' as _iy2evbc1;
import 'friend/lobby_view.dart' as _iwcao3ye;
import 'friend/match_view.dart' as _in465to7;
import 'friend/penalty_kick.dart' as _i85b7jsg;
import 'friend/queue_entry.dart' as _iju54wrt;
import 'friend/queue_status.dart' as _i5f66tdj;
import 'friend/signal_view.dart' as _iwiyctoy;
import 'game_exception.dart' as _iva62vub;
import 'profile/user_profile.dart' as _ik2xsncp;
import 'rankings/achievement_view.dart' as _imlks8jq;
import 'rankings/challenge_view.dart' as _iq5zczhp;
import 'rankings/leader_entry.dart' as _i4ke8vzx;
import 'rankings/leaderboard_view.dart' as _ikumlxuj;
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
import 'social/share_link.dart' as _ibfawpjk;
import 'social/shared_result.dart' as _i3481sdt;
import 'social/user_block.dart' as _ib9qj8iy;
import 'tournament/standing_row.dart' as _ip1i4so6;
import 'tournament/tournament.dart' as _ihp9r9tf;
import 'tournament/tournament_fixture.dart' as _iz6ze9lg;
import 'tournament/tournament_view.dart' as _i8117dck;
export 'friend/duel_view.dart';
export 'friend/friend_match.dart';
export 'friend/kick_due.dart';
export 'friend/kick_view.dart';
export 'friend/lobby.dart';
export 'friend/lobby_view.dart';
export 'friend/match_view.dart';
export 'friend/penalty_kick.dart';
export 'friend/queue_entry.dart';
export 'friend/queue_status.dart';
export 'friend/signal_view.dart';
export 'game_exception.dart';
export 'profile/user_profile.dart';
export 'rankings/achievement_view.dart';
export 'rankings/challenge_view.dart';
export 'rankings/leader_entry.dart';
export 'rankings/leaderboard_view.dart';
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
export 'social/share_link.dart';
export 'social/shared_result.dart';
export 'social/user_block.dart';
export 'tournament/standing_row.dart';
export 'tournament/tournament.dart';
export 'tournament/tournament_fixture.dart';
export 'tournament/tournament_view.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

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
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ie4eb5hy.DuelView) {
      return _ie4eb5hy.DuelView.fromJson(data) as T;
    }
    if (t == _i61u4k1q.FriendMatch) {
      return _i61u4k1q.FriendMatch.fromJson(data) as T;
    }
    if (t == _ikj0u1ic.KickDue) {
      return _ikj0u1ic.KickDue.fromJson(data) as T;
    }
    if (t == _i9hpe2st.KickView) {
      return _i9hpe2st.KickView.fromJson(data) as T;
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
    if (t == _i85b7jsg.PenaltyKick) {
      return _i85b7jsg.PenaltyKick.fromJson(data) as T;
    }
    if (t == _iju54wrt.QueueEntry) {
      return _iju54wrt.QueueEntry.fromJson(data) as T;
    }
    if (t == _i5f66tdj.QueueStatus) {
      return _i5f66tdj.QueueStatus.fromJson(data) as T;
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
    if (t == _imlks8jq.AchievementView) {
      return _imlks8jq.AchievementView.fromJson(data) as T;
    }
    if (t == _iq5zczhp.ChallengeView) {
      return _iq5zczhp.ChallengeView.fromJson(data) as T;
    }
    if (t == _i4ke8vzx.LeaderEntry) {
      return _i4ke8vzx.LeaderEntry.fromJson(data) as T;
    }
    if (t == _ikumlxuj.LeaderboardView) {
      return _ikumlxuj.LeaderboardView.fromJson(data) as T;
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
    if (t == _ibfawpjk.ShareLink) {
      return _ibfawpjk.ShareLink.fromJson(data) as T;
    }
    if (t == _i3481sdt.SharedResult) {
      return _i3481sdt.SharedResult.fromJson(data) as T;
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
    if (t == _isc.getType<_ie4eb5hy.DuelView?>()) {
      return (data != null ? _ie4eb5hy.DuelView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i61u4k1q.FriendMatch?>()) {
      return (data != null ? _i61u4k1q.FriendMatch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikj0u1ic.KickDue?>()) {
      return (data != null ? _ikj0u1ic.KickDue.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i9hpe2st.KickView?>()) {
      return (data != null ? _i9hpe2st.KickView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iy2evbc1.Lobby?>()) {
      return (data != null ? _iy2evbc1.Lobby.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iwcao3ye.LobbyView?>()) {
      return (data != null ? _iwcao3ye.LobbyView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_in465to7.MatchView?>()) {
      return (data != null ? _in465to7.MatchView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i85b7jsg.PenaltyKick?>()) {
      return (data != null ? _i85b7jsg.PenaltyKick.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iju54wrt.QueueEntry?>()) {
      return (data != null ? _iju54wrt.QueueEntry.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5f66tdj.QueueStatus?>()) {
      return (data != null ? _i5f66tdj.QueueStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iwiyctoy.SignalView?>()) {
      return (data != null ? _iwiyctoy.SignalView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iva62vub.GameException?>()) {
      return (data != null ? _iva62vub.GameException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ik2xsncp.UserProfile?>()) {
      return (data != null ? _ik2xsncp.UserProfile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_imlks8jq.AchievementView?>()) {
      return (data != null ? _imlks8jq.AchievementView.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iq5zczhp.ChallengeView?>()) {
      return (data != null ? _iq5zczhp.ChallengeView.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4ke8vzx.LeaderEntry?>()) {
      return (data != null ? _i4ke8vzx.LeaderEntry.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikumlxuj.LeaderboardView?>()) {
      return (data != null ? _ikumlxuj.LeaderboardView.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ih7dxm8c.AdminStats?>()) {
      return (data != null ? _ih7dxm8c.AdminStats.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2419br0.AuditLog?>()) {
      return (data != null ? _i2419br0.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixke9pf1.ChatLine?>()) {
      return (data != null ? _ixke9pf1.ChatLine.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isb39j3s.FriendsView?>()) {
      return (data != null ? _isb39j3s.FriendsView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i76eh3vl.Friendship?>()) {
      return (data != null ? _i76eh3vl.Friendship.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ioxid9pm.HeadToHead?>()) {
      return (data != null ? _ioxid9pm.HeadToHead.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibhxaxmh.InviteView?>()) {
      return (data != null ? _ibhxaxmh.InviteView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0ak7238.LiveOps?>()) {
      return (data != null ? _i0ak7238.LiveOps.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_inm7enqw.LiveStatus?>()) {
      return (data != null ? _inm7enqw.LiveStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_im6jgtvt.LobbyInvite?>()) {
      return (data != null ? _im6jgtvt.LobbyInvite.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ipshgsbn.LobbyMessage?>()) {
      return (data != null ? _ipshgsbn.LobbyMessage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2tinm30.PersonView?>()) {
      return (data != null ? _i2tinm30.PersonView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i7lceyce.PlayerReport?>()) {
      return (data != null ? _i7lceyce.PlayerReport.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iaqb5f9o.RecordView?>()) {
      return (data != null ? _iaqb5f9o.RecordView.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibfawpjk.ShareLink?>()) {
      return (data != null ? _ibfawpjk.ShareLink.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3481sdt.SharedResult?>()) {
      return (data != null ? _i3481sdt.SharedResult.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ib9qj8iy.UserBlock?>()) {
      return (data != null ? _ib9qj8iy.UserBlock.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ip1i4so6.StandingRow?>()) {
      return (data != null ? _ip1i4so6.StandingRow.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihp9r9tf.Tournament?>()) {
      return (data != null ? _ihp9r9tf.Tournament.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iz6ze9lg.TournamentFixture?>()) {
      return (data != null ? _iz6ze9lg.TournamentFixture.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8117dck.TournamentView?>()) {
      return (data != null ? _i8117dck.TournamentView.fromJson(data) : null)
          as T;
    }
    if (t == List<_i9hpe2st.KickView>) {
      return (data as List)
              .map((e) => deserialize<_i9hpe2st.KickView>(e))
              .toList()
          as T;
    }
    if (t == List<_i4ke8vzx.LeaderEntry>) {
      return (data as List)
              .map((e) => deserialize<_i4ke8vzx.LeaderEntry>(e))
              .toList()
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
    if (t == List<_i4p1u5ur.MatchView>) {
      return (data as List)
              .map((e) => deserialize<_i4p1u5ur.MatchView>(e))
              .toList()
          as T;
    }
    if (t == List<_iqx1bsph.AchievementView>) {
      return (data as List)
              .map((e) => deserialize<_iqx1bsph.AchievementView>(e))
              .toList()
          as T;
    }
    if (t == List<_iy4xom0n.ChatLine>) {
      return (data as List)
              .map((e) => deserialize<_iy4xom0n.ChatLine>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ie4eb5hy.DuelView => 'DuelView',
      _i61u4k1q.FriendMatch => 'FriendMatch',
      _ikj0u1ic.KickDue => 'KickDue',
      _i9hpe2st.KickView => 'KickView',
      _iy2evbc1.Lobby => 'Lobby',
      _iwcao3ye.LobbyView => 'LobbyView',
      _in465to7.MatchView => 'MatchView',
      _i85b7jsg.PenaltyKick => 'PenaltyKick',
      _iju54wrt.QueueEntry => 'QueueEntry',
      _i5f66tdj.QueueStatus => 'QueueStatus',
      _iwiyctoy.SignalView => 'SignalView',
      _iva62vub.GameException => 'GameException',
      _ik2xsncp.UserProfile => 'UserProfile',
      _imlks8jq.AchievementView => 'AchievementView',
      _iq5zczhp.ChallengeView => 'ChallengeView',
      _i4ke8vzx.LeaderEntry => 'LeaderEntry',
      _ikumlxuj.LeaderboardView => 'LeaderboardView',
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
      _ibfawpjk.ShareLink => 'ShareLink',
      _i3481sdt.SharedResult => 'SharedResult',
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
      case _ie4eb5hy.DuelView():
        return 'DuelView';
      case _i61u4k1q.FriendMatch():
        return 'FriendMatch';
      case _ikj0u1ic.KickDue():
        return 'KickDue';
      case _i9hpe2st.KickView():
        return 'KickView';
      case _iy2evbc1.Lobby():
        return 'Lobby';
      case _iwcao3ye.LobbyView():
        return 'LobbyView';
      case _in465to7.MatchView():
        return 'MatchView';
      case _i85b7jsg.PenaltyKick():
        return 'PenaltyKick';
      case _iju54wrt.QueueEntry():
        return 'QueueEntry';
      case _i5f66tdj.QueueStatus():
        return 'QueueStatus';
      case _iwiyctoy.SignalView():
        return 'SignalView';
      case _iva62vub.GameException():
        return 'GameException';
      case _ik2xsncp.UserProfile():
        return 'UserProfile';
      case _imlks8jq.AchievementView():
        return 'AchievementView';
      case _iq5zczhp.ChallengeView():
        return 'ChallengeView';
      case _i4ke8vzx.LeaderEntry():
        return 'LeaderEntry';
      case _ikumlxuj.LeaderboardView():
        return 'LeaderboardView';
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
      case _ibfawpjk.ShareLink():
        return 'ShareLink';
      case _i3481sdt.SharedResult():
        return 'SharedResult';
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
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'DuelView') {
      return deserialize<_ie4eb5hy.DuelView>(data['data']);
    }
    if (dataClassName == 'FriendMatch') {
      return deserialize<_i61u4k1q.FriendMatch>(data['data']);
    }
    if (dataClassName == 'KickDue') {
      return deserialize<_ikj0u1ic.KickDue>(data['data']);
    }
    if (dataClassName == 'KickView') {
      return deserialize<_i9hpe2st.KickView>(data['data']);
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
    if (dataClassName == 'PenaltyKick') {
      return deserialize<_i85b7jsg.PenaltyKick>(data['data']);
    }
    if (dataClassName == 'QueueEntry') {
      return deserialize<_iju54wrt.QueueEntry>(data['data']);
    }
    if (dataClassName == 'QueueStatus') {
      return deserialize<_i5f66tdj.QueueStatus>(data['data']);
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
    if (dataClassName == 'AchievementView') {
      return deserialize<_imlks8jq.AchievementView>(data['data']);
    }
    if (dataClassName == 'ChallengeView') {
      return deserialize<_iq5zczhp.ChallengeView>(data['data']);
    }
    if (dataClassName == 'LeaderEntry') {
      return deserialize<_i4ke8vzx.LeaderEntry>(data['data']);
    }
    if (dataClassName == 'LeaderboardView') {
      return deserialize<_ikumlxuj.LeaderboardView>(data['data']);
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
    if (dataClassName == 'ShareLink') {
      return deserialize<_ibfawpjk.ShareLink>(data['data']);
    }
    if (dataClassName == 'SharedResult') {
      return deserialize<_i3481sdt.SharedResult>(data['data']);
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
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('football', this);
    _iacc.Protocol().registerHostProtocol('football', this);
  }

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
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
