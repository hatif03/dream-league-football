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
import 'dart:async' as _ida;
import 'package:football_client/src/protocol/friend/duel_view.dart'
    as _i1k1uww2;
import 'package:football_client/src/protocol/friend/lobby_view.dart'
    as _ia920rmv;
import 'package:football_client/src/protocol/friend/match_view.dart'
    as _i4p1u5ur;
import 'package:football_client/src/protocol/friend/queue_status.dart'
    as _iuvlb6b0;
import 'package:football_client/src/protocol/friend/signal_view.dart'
    as _i54q09el;
import 'package:football_client/src/protocol/profile/user_profile.dart'
    as _ihl7iimi;
import 'package:football_client/src/protocol/rankings/achievement_view.dart'
    as _iqx1bsph;
import 'package:football_client/src/protocol/rankings/challenge_view.dart'
    as _iufwcfuk;
import 'package:football_client/src/protocol/rankings/leaderboard_view.dart'
    as _ib83d9xt;
import 'package:football_client/src/protocol/social/admin_stats.dart'
    as _id6gu71f;
import 'package:football_client/src/protocol/social/chat_line.dart'
    as _iy4xom0n;
import 'package:football_client/src/protocol/social/friends_view.dart'
    as _iil7n3fb;
import 'package:football_client/src/protocol/social/live_status.dart'
    as _i23azn6q;
import 'package:football_client/src/protocol/social/record_view.dart'
    as _imm1597n;
import 'package:football_client/src/protocol/social/share_link.dart'
    as _im0wvngs;
import 'package:football_client/src/protocol/tournament/tournament_view.dart'
    as _icans0sd;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Public: lets the sign-in screen and the lobby know about maintenance.
/// {@category Endpoint}
class EndpointLiveOps extends _isc.EndpointRef {
  EndpointLiveOps(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'liveOps';

  _ida.Future<_i23azn6q.LiveStatus> get() =>
      caller.callServerEndpoint<_i23azn6q.LiveStatus>(
        'liveOps',
        'get',
        {},
      );
}

/// Operator tools. Callable only by the user ids listed (comma separated) in the
/// `adminUserIds` password: `scloud password set adminUserIds <id>[,<id>]`.
/// {@category Endpoint}
class EndpointAdmin extends _isc.EndpointRef {
  EndpointAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  /// Turns maintenance on or off. New rooms are refused while it is on; sign-in and
  /// matches already running carry on.
  _ida.Future<_i23azn6q.LiveStatus> setMaintenance(
    bool on,
    String? message,
  ) => caller.callServerEndpoint<_i23azn6q.LiveStatus>(
    'admin',
    'setMaintenance',
    {
      'on': on,
      'message': message,
    },
  );

  /// Suspends a player by display name for [hours], or lifts the suspension with 0.
  _ida.Future<void> suspend(
    String name,
    int hours,
  ) => caller.callServerEndpoint<void>(
    'admin',
    'suspend',
    {
      'name': name,
      'hours': hours,
    },
  );

  /// Marks a friend match void so it counts for nobody.
  _ida.Future<void> voidMatch(
    _isc.UuidValue matchId,
    String reason,
  ) => caller.callServerEndpoint<void>(
    'admin',
    'voidMatch',
    {
      'matchId': matchId,
      'reason': reason,
    },
  );

  _ida.Future<_id6gu71f.AdminStats> stats() =>
      caller.callServerEndpoint<_id6gu71f.AdminStats>(
        'admin',
        'stats',
        {},
      );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointFriendMatch extends _isc.EndpointRef {
  EndpointFriendMatch(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'friendMatch';

  _ida.Future<_i4p1u5ur.MatchView> get(_isc.UuidValue matchId) =>
      caller.callServerEndpoint<_i4p1u5ur.MatchView>(
        'friendMatch',
        'get',
        {'matchId': matchId},
      );

  /// Host posts the WebRTC offer (with every ICE candidate already in it).
  _ida.Future<void> postOffer(
    _isc.UuidValue matchId,
    String sdp,
  ) => caller.callServerEndpoint<void>(
    'friendMatch',
    'postOffer',
    {
      'matchId': matchId,
      'sdp': sdp,
    },
  );

  /// Guest posts the answer to the host's offer.
  _ida.Future<void> postAnswer(
    _isc.UuidValue matchId,
    String sdp,
  ) => caller.callServerEndpoint<void>(
    'friendMatch',
    'postAnswer',
    {
      'matchId': matchId,
      'sdp': sdp,
    },
  );

  /// Polled by both peers until the handshake completes.
  _ida.Future<_i54q09el.SignalView> getSignal(_isc.UuidValue matchId) =>
      caller.callServerEndpoint<_i54q09el.SignalView>(
        'friendMatch',
        'getSignal',
        {'matchId': matchId},
      );

  /// Either peer reports how the match is connected; the handshake is then cleared.
  _ida.Future<void> connected(
    _isc.UuidValue matchId,
    String transport,
  ) => caller.callServerEndpoint<void>(
    'friendMatch',
    'connected',
    {
      'matchId': matchId,
      'transport': transport,
    },
  );

  /// The caller walks out of a match that is still being played. It ends at once as
  /// abandoned, naming them as the one who left, so the opponent is told immediately
  /// instead of waiting out the reconnect and signing windows. A player who already
  /// signed full time is not treated as leaving.
  _ida.Future<_i4p1u5ur.MatchView> leave(_isc.UuidValue matchId) =>
      caller.callServerEndpoint<_i4p1u5ur.MatchView>(
        'friendMatch',
        'leave',
        {'matchId': matchId},
      );

  /// Signs the result as the caller sees it. [reason] is `fulltime`, or
  /// `abandoned` when the opponent left. Posting the same claim twice is fine.
  _ida.Future<_i4p1u5ur.MatchView> claim(
    _isc.UuidValue matchId,
    int hostGoals,
    int guestGoals,
    String reason,
    String? stats,
  ) => caller.callServerEndpoint<_i4p1u5ur.MatchView>(
    'friendMatch',
    'claim',
    {
      'matchId': matchId,
      'hostGoals': hostGoals,
      'guestGoals': guestGoals,
      'reason': reason,
      'stats': stats,
    },
  );

  /// The caller's recent friend matches, newest first.
  _ida.Future<List<_i4p1u5ur.MatchView>> history(int limit) =>
      caller.callServerEndpoint<List<_i4p1u5ur.MatchView>>(
        'friendMatch',
        'history',
        {'limit': limit},
      );
}

/// {@category Endpoint}
class EndpointLobby extends _isc.EndpointRef {
  EndpointLobby(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'lobby';

  /// Opens a room; the caller is the host (their browser runs the simulation of a full match).
  /// [mode] is `match` (the default) or `penalties`, a penalty duel the server referees.
  _ida.Future<_ia920rmv.LobbyView> create(
    String clientVersion,
    String? mode,
  ) => caller.callServerEndpoint<_ia920rmv.LobbyView>(
    'lobby',
    'create',
    {
      'clientVersion': clientVersion,
      'mode': mode,
    },
  );

  /// Joins an open room by its code as the guest.
  _ida.Future<_ia920rmv.LobbyView> join(
    String code,
    String clientVersion,
  ) => caller.callServerEndpoint<_ia920rmv.LobbyView>(
    'lobby',
    'join',
    {
      'code': code,
      'clientVersion': clientVersion,
    },
  );

  /// The current state of a room, for polling.
  _ida.Future<_ia920rmv.LobbyView> get(_isc.UuidValue lobbyId) =>
      caller.callServerEndpoint<_ia920rmv.LobbyView>(
        'lobby',
        'get',
        {'lobbyId': lobbyId},
      );

  _ida.Future<_ia920rmv.LobbyView> setNation(
    _isc.UuidValue lobbyId,
    String nationId,
  ) => caller.callServerEndpoint<_ia920rmv.LobbyView>(
    'lobby',
    'setNation',
    {
      'lobbyId': lobbyId,
      'nationId': nationId,
    },
  );

  /// Marks the caller ready. When both are ready the match row is created.
  _ida.Future<_ia920rmv.LobbyView> setReady(
    _isc.UuidValue lobbyId,
    bool ready,
  ) => caller.callServerEndpoint<_ia920rmv.LobbyView>(
    'lobby',
    'setReady',
    {
      'lobbyId': lobbyId,
      'ready': ready,
    },
  );

  /// Leaves the room. The host leaving closes it; a guest leaving frees the seat.
  _ida.Future<void> leave(_isc.UuidValue lobbyId) =>
      caller.callServerEndpoint<void>(
        'lobby',
        'leave',
        {'lobbyId': lobbyId},
      );

  /// Starts a rematch from a finished match: a fresh room, host and guest swapped,
  /// nations kept. Whichever player asks first creates it; the other gets the same room.
  _ida.Future<_ia920rmv.LobbyView> rematch(
    _isc.UuidValue lobbyId,
    String clientVersion,
  ) => caller.callServerEndpoint<_ia920rmv.LobbyView>(
    'lobby',
    'rematch',
    {
      'lobbyId': lobbyId,
      'clientVersion': clientVersion,
    },
  );
}

/// The penalty duel: the server is the referee. Each kick, the shooter picks where to shoot and the
/// keeper where to dive, both in secret; when both have chosen the server draws the result with its own
/// randomness. Nothing runs in a browser that a player could tamper with, and neither side has a
/// latency advantage.
/// {@category Endpoint}
class EndpointPenalty extends _isc.EndpointRef {
  EndpointPenalty(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'penalty';

  /// The duel as the caller sees it. Also settles a kick whose time has run out.
  _ida.Future<_i1k1uww2.DuelView> state(_isc.UuidValue matchId) =>
      caller.callServerEndpoint<_i1k1uww2.DuelView>(
        'penalty',
        'state',
        {'matchId': matchId},
      );

  /// The caller's choice for kick [seq]: a zone from 0 to 5 (shoot there, or dive there).
  /// Choosing again for the same kick changes nothing.
  _ida.Future<_i1k1uww2.DuelView> submit(
    _isc.UuidValue matchId,
    int seq,
    int zone,
  ) => caller.callServerEndpoint<_i1k1uww2.DuelView>(
    'penalty',
    'submit',
    {
      'matchId': matchId,
      'seq': seq,
      'zone': zone,
    },
  );
}

/// Find an opponent without needing a friend: players press "Find a match", the server pairs two who are
/// waiting for the same game with a similar rating (a wider net the longer they wait), seats them in a
/// room with nations chosen for them, and starts the match.
/// {@category Endpoint}
class EndpointMatchmaking extends _isc.EndpointRef {
  EndpointMatchmaking(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'matchmaking';

  /// Joins the queue for [mode] (`match` or `penalties`) and returns where things stand.
  _ida.Future<_iuvlb6b0.QueueStatus> join(
    String mode,
    String clientVersion,
  ) => caller.callServerEndpoint<_iuvlb6b0.QueueStatus>(
    'matchmaking',
    'join',
    {
      'mode': mode,
      'clientVersion': clientVersion,
    },
  );

  /// Where the caller's search stands. Asking also keeps the search alive and tries to pair again.
  _ida.Future<_iuvlb6b0.QueueStatus> status() =>
      caller.callServerEndpoint<_iuvlb6b0.QueueStatus>(
        'matchmaking',
        'status',
        {},
      );

  /// Stops searching. A match that was already found stays.
  _ida.Future<void> cancel() => caller.callServerEndpoint<void>(
    'matchmaking',
    'cancel',
    {},
  );
}

/// {@category Endpoint}
class EndpointProfile extends _isc.EndpointRef {
  EndpointProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  /// The caller's profile, or null before they have picked a display name.
  _ida.Future<_ihl7iimi.UserProfile?> me() =>
      caller.callServerEndpoint<_ihl7iimi.UserProfile?>(
        'profile',
        'me',
        {},
      );

  _ida.Future<bool> isNameAvailable(String displayName) =>
      caller.callServerEndpoint<bool>(
        'profile',
        'isNameAvailable',
        {'displayName': displayName},
      );

  _ida.Future<_ihl7iimi.UserProfile> createProfile(
    String displayName,
    bool acceptTerms,
  ) => caller.callServerEndpoint<_ihl7iimi.UserProfile>(
    'profile',
    'createProfile',
    {
      'displayName': displayName,
      'acceptTerms': acceptTerms,
    },
  );

  _ida.Future<_ihl7iimi.UserProfile> updateProfile(
    String? region,
    String? favouriteNation,
  ) => caller.callServerEndpoint<_ihl7iimi.UserProfile>(
    'profile',
    'updateProfile',
    {
      'region': region,
      'favouriteNation': favouriteNation,
    },
  );

  /// Picks one of the pre-made avatars (0 to 23).
  _ida.Future<_ihl7iimi.UserProfile> setAvatar(int avatar) =>
      caller.callServerEndpoint<_ihl7iimi.UserProfile>(
        'profile',
        'setAvatar',
        {'avatar': avatar},
      );

  /// Saves the player's settings (a JSON object, at most 8 KB) so they follow them to other devices.
  _ida.Future<_ihl7iimi.UserProfile> saveSettings(String json) =>
      caller.callServerEndpoint<_ihl7iimi.UserProfile>(
        'profile',
        'saveSettings',
        {'json': json},
      );

  /// Saves the player's club crest and kit (a JSON object, at most 2 KB).
  _ida.Future<_ihl7iimi.UserProfile> saveClub(String json) =>
      caller.callServerEndpoint<_ihl7iimi.UserProfile>(
        'profile',
        'saveClub',
        {'json': json},
      );

  /// Friend-match record: wins, draws, losses, abandoned matches, and per-opponent results.
  /// A draw is a draw. An abandoned or void match counts for nobody.
  _ida.Future<_imm1597n.RecordView> record() =>
      caller.callServerEndpoint<_imm1597n.RecordView>(
        'profile',
        'record',
        {},
      );

  /// Deletes the account and its personal data. Finished friend matches stay for the
  /// other player, who sees "Removed player".
  _ida.Future<void> deleteAccount() => caller.callServerEndpoint<void>(
    'profile',
    'deleteAccount',
    {},
  );
}

/// The daily challenge: one goal a day, the same for everybody, derived from the date. Progress and the
/// streak are computed from the finished online matches already stored, so nothing extra is written.
/// {@category Endpoint}
class EndpointChallenges extends _isc.EndpointRef {
  EndpointChallenges(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'challenges';

  _ida.Future<_iufwcfuk.ChallengeView> today() =>
      caller.callServerEndpoint<_iufwcfuk.ChallengeView>(
        'challenges',
        'today',
        {},
      );
}

/// Rankings and achievements, both derived from the matches and World Cup runs already stored.
/// {@category Endpoint}
class EndpointRankings extends _isc.EndpointRef {
  EndpointRankings(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rankings';

  /// The top [limit] players (at most 50) and the caller's own row, ranked `by` `rating` (Elo, from friend matches
  /// and penalty duels) or `points` (wins, draws and World Cup titles).
  _ida.Future<_ib83d9xt.LeaderboardView> leaderboard(
    int limit,
    String? by,
  ) => caller.callServerEndpoint<_ib83d9xt.LeaderboardView>(
    'rankings',
    'leaderboard',
    {
      'limit': limit,
      'by': by,
    },
  );

  /// Every achievement with the caller's progress.
  _ida.Future<List<_iqx1bsph.AchievementView>> achievements() =>
      caller.callServerEndpoint<List<_iqx1bsph.AchievementView>>(
        'rankings',
        'achievements',
        {},
      );
}

/// {@category Endpoint}
class EndpointChat extends _isc.EndpointRef {
  EndpointChat(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'chat';

  /// Posts a line in a room the caller is in.
  _ida.Future<void> send(
    _isc.UuidValue lobbyId,
    String text,
  ) => caller.callServerEndpoint<void>(
    'chat',
    'send',
    {
      'lobbyId': lobbyId,
      'text': text,
    },
  );

  /// The latest lines of a room, oldest first. Lines from players the caller blocked are hidden.
  _ida.Future<List<_iy4xom0n.ChatLine>> list(_isc.UuidValue lobbyId) =>
      caller.callServerEndpoint<List<_iy4xom0n.ChatLine>>(
        'chat',
        'list',
        {'lobbyId': lobbyId},
      );
}

/// {@category Endpoint}
class EndpointFriends extends _isc.EndpointRef {
  EndpointFriends(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'friends';

  /// Friends, pending requests, blocks and room invites for the caller.
  _ida.Future<_iil7n3fb.FriendsView> list() =>
      caller.callServerEndpoint<_iil7n3fb.FriendsView>(
        'friends',
        'list',
        {},
      );

  /// Sends a friend request by exact display name (case does not matter).
  _ida.Future<_iil7n3fb.FriendsView> request(String name) =>
      caller.callServerEndpoint<_iil7n3fb.FriendsView>(
        'friends',
        'request',
        {'name': name},
      );

  _ida.Future<_iil7n3fb.FriendsView> accept(String userId) =>
      caller.callServerEndpoint<_iil7n3fb.FriendsView>(
        'friends',
        'accept',
        {'userId': userId},
      );

  /// Declines a request, cancels one you sent, or removes a friend.
  _ida.Future<_iil7n3fb.FriendsView> remove(String userId) =>
      caller.callServerEndpoint<_iil7n3fb.FriendsView>(
        'friends',
        'remove',
        {'userId': userId},
      );

  /// Blocks a player: the friendship ends and neither can invite or join the other.
  _ida.Future<_iil7n3fb.FriendsView> block(String userId) =>
      caller.callServerEndpoint<_iil7n3fb.FriendsView>(
        'friends',
        'block',
        {'userId': userId},
      );

  _ida.Future<_iil7n3fb.FriendsView> unblock(String userId) =>
      caller.callServerEndpoint<_iil7n3fb.FriendsView>(
        'friends',
        'unblock',
        {'userId': userId},
      );

  /// The host invites a friend into their open room.
  _ida.Future<void> invite(
    String userId,
    _isc.UuidValue lobbyId,
  ) => caller.callServerEndpoint<void>(
    'friends',
    'invite',
    {
      'userId': userId,
      'lobbyId': lobbyId,
    },
  );

  _ida.Future<_iil7n3fb.FriendsView> dismissInvite(_isc.UuidValue lobbyId) =>
      caller.callServerEndpoint<_iil7n3fb.FriendsView>(
        'friends',
        'dismissInvite',
        {'lobbyId': lobbyId},
      );
}

/// {@category Endpoint}
class EndpointReport extends _isc.EndpointRef {
  EndpointReport(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'report';

  /// Reports a player. When [matchId] is given the caller must have been in that match
  /// against the player, so reports carry real context.
  _ida.Future<void> create(
    String targetUserId,
    _isc.UuidValue? matchId,
    String reason,
  ) => caller.callServerEndpoint<void>(
    'report',
    'create',
    {
      'targetUserId': targetUserId,
      'matchId': matchId,
      'reason': reason,
    },
  );
}

/// Sharing a result as a link. The picture of the score is kept in Serverpod's cloud storage and the link
/// `/r/<id>` (served by [ShareRoute]) is a small page whose Open Graph tags make chat apps and social
/// networks show the picture as a preview.
/// {@category Endpoint}
class EndpointShare extends _isc.EndpointRef {
  EndpointShare(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'share';

  /// Stores a result image (a PNG sent as base64, at most 400 KB) and returns the link id and the image's public URL.
  _ida.Future<_im0wvngs.ShareLink> createResult(
    String pngBase64,
    String title,
    String description,
  ) => caller.callServerEndpoint<_im0wvngs.ShareLink>(
    'share',
    'createResult',
    {
      'pngBase64': pngBase64,
      'title': title,
      'description': description,
    },
  );
}

/// {@category Endpoint}
class EndpointTournament extends _isc.EndpointRef {
  EndpointTournament(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'tournament';

  /// The caller's most recent run, or null if they never started one.
  _ida.Future<_icans0sd.TournamentView?> current() =>
      caller.callServerEndpoint<_icans0sd.TournamentView?>(
        'tournament',
        'current',
        {},
      );

  /// Starts a run as [nationId]. Only one run may be in progress.
  _ida.Future<_icans0sd.TournamentView> start(String nationId) =>
      caller.callServerEndpoint<_icans0sd.TournamentView>(
        'tournament',
        'start',
        {'nationId': nationId},
      );

  /// Drops the run in progress so the player can start another.
  _ida.Future<void> abandon() => caller.callServerEndpoint<void>(
    'tournament',
    'abandon',
    {},
  );

  /// Saves the score of the fixture the player just played.
  ///
  /// Group stage: the other games on that same matchday are simulated (never later ones).
  /// Knockouts: a level game needs shootout goals; the other ties of the round are simulated,
  /// then the next round is drawn from the winners. Sending the same [nonce] again returns
  /// the saved state instead of failing.
  _ida.Future<_icans0sd.TournamentView> submitResult(
    _isc.UuidValue tournamentId,
    _isc.UuidValue fixtureId,
    String nonce,
    int homeScore,
    int awayScore,
    int? homePens,
    int? awayPens,
    String? decidedBy,
  ) => caller.callServerEndpoint<_icans0sd.TournamentView>(
    'tournament',
    'submitResult',
    {
      'tournamentId': tournamentId,
      'fixtureId': fixtureId,
      'nonce': nonce,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'homePens': homePens,
      'awayPens': awayPens,
      'decidedBy': decidedBy,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    liveOps = EndpointLiveOps(this);
    admin = EndpointAdmin(this);
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    friendMatch = EndpointFriendMatch(this);
    lobby = EndpointLobby(this);
    penalty = EndpointPenalty(this);
    matchmaking = EndpointMatchmaking(this);
    profile = EndpointProfile(this);
    challenges = EndpointChallenges(this);
    rankings = EndpointRankings(this);
    chat = EndpointChat(this);
    friends = EndpointFriends(this);
    report = EndpointReport(this);
    share = EndpointShare(this);
    tournament = EndpointTournament(this);
    modules = Modules(this);
  }

  late final EndpointLiveOps liveOps;

  late final EndpointAdmin admin;

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointFriendMatch friendMatch;

  late final EndpointLobby lobby;

  late final EndpointPenalty penalty;

  late final EndpointMatchmaking matchmaking;

  late final EndpointProfile profile;

  late final EndpointChallenges challenges;

  late final EndpointRankings rankings;

  late final EndpointChat chat;

  late final EndpointFriends friends;

  late final EndpointReport report;

  late final EndpointShare share;

  late final EndpointTournament tournament;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'liveOps': liveOps,
    'admin': admin,
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'friendMatch': friendMatch,
    'lobby': lobby,
    'penalty': penalty,
    'matchmaking': matchmaking,
    'profile': profile,
    'challenges': challenges,
    'rankings': rankings,
    'chat': chat,
    'friends': friends,
    'report': report,
    'share': share,
    'tournament': tournament,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
