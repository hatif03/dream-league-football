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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../admin/admin_endpoint.dart' as _ido5l6pj;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../friend/friend_match_endpoint.dart' as _i3eu9671;
import '../friend/lobby_endpoint.dart' as _ixxnzf3o;
import '../profile/profile_endpoint.dart' as _i6ky944g;
import '../social/chat_endpoint.dart' as _ib6swwnz;
import '../social/friends_endpoint.dart' as _iejqgreb;
import '../social/report_endpoint.dart' as _i5mkv7jo;
import '../tournament/tournament_endpoint.dart' as _i6ilfrpl;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'liveOps': _ido5l6pj.LiveOpsEndpoint()
        ..initialize(
          server,
          'liveOps',
          null,
        ),
      'admin': _ido5l6pj.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'friendMatch': _i3eu9671.FriendMatchEndpoint()
        ..initialize(
          server,
          'friendMatch',
          null,
        ),
      'lobby': _ixxnzf3o.LobbyEndpoint()
        ..initialize(
          server,
          'lobby',
          null,
        ),
      'profile': _i6ky944g.ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
      'chat': _ib6swwnz.ChatEndpoint()
        ..initialize(
          server,
          'chat',
          null,
        ),
      'friends': _iejqgreb.FriendsEndpoint()
        ..initialize(
          server,
          'friends',
          null,
        ),
      'report': _i5mkv7jo.ReportEndpoint()
        ..initialize(
          server,
          'report',
          null,
        ),
      'tournament': _i6ilfrpl.TournamentEndpoint()
        ..initialize(
          server,
          'tournament',
          null,
        ),
    };
    connectors['liveOps'] = _is.EndpointConnector(
      name: 'liveOps',
      endpoint: endpoints['liveOps']!,
      methodConnectors: {
        'get': _is.MethodConnector(
          name: 'get',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['liveOps'] as _ido5l6pj.LiveOpsEndpoint)
                  .get(session),
        ),
      },
    );
    connectors['admin'] = _is.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'setMaintenance': _is.MethodConnector(
          name: 'setMaintenance',
          params: {
            'on': _is.ParameterDescription(
              name: 'on',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'message': _is.ParameterDescription(
              name: 'message',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _ido5l6pj.AdminEndpoint)
                  .setMaintenance(
                    session,
                    params['on'],
                    params['message'],
                  ),
        ),
        'suspend': _is.MethodConnector(
          name: 'suspend',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'hours': _is.ParameterDescription(
              name: 'hours',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _ido5l6pj.AdminEndpoint).suspend(
                    session,
                    params['name'],
                    params['hours'],
                  ),
        ),
        'voidMatch': _is.MethodConnector(
          name: 'voidMatch',
          params: {
            'matchId': _is.ParameterDescription(
              name: 'matchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _ido5l6pj.AdminEndpoint).voidMatch(
                    session,
                    params['matchId'],
                    params['reason'],
                  ),
        ),
        'stats': _is.MethodConnector(
          name: 'stats',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _ido5l6pj.AdminEndpoint).stats(
                session,
              ),
        ),
      },
    );
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['friendMatch'] = _is.EndpointConnector(
      name: 'friendMatch',
      endpoint: endpoints['friendMatch']!,
      methodConnectors: {
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'matchId': _is.ParameterDescription(
              name: 'matchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friendMatch'] as _i3eu9671.FriendMatchEndpoint)
                      .get(
                        session,
                        params['matchId'],
                      ),
        ),
        'postOffer': _is.MethodConnector(
          name: 'postOffer',
          params: {
            'matchId': _is.ParameterDescription(
              name: 'matchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sdp': _is.ParameterDescription(
              name: 'sdp',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friendMatch'] as _i3eu9671.FriendMatchEndpoint)
                      .postOffer(
                        session,
                        params['matchId'],
                        params['sdp'],
                      ),
        ),
        'postAnswer': _is.MethodConnector(
          name: 'postAnswer',
          params: {
            'matchId': _is.ParameterDescription(
              name: 'matchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sdp': _is.ParameterDescription(
              name: 'sdp',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friendMatch'] as _i3eu9671.FriendMatchEndpoint)
                      .postAnswer(
                        session,
                        params['matchId'],
                        params['sdp'],
                      ),
        ),
        'getSignal': _is.MethodConnector(
          name: 'getSignal',
          params: {
            'matchId': _is.ParameterDescription(
              name: 'matchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friendMatch'] as _i3eu9671.FriendMatchEndpoint)
                      .getSignal(
                        session,
                        params['matchId'],
                      ),
        ),
        'connected': _is.MethodConnector(
          name: 'connected',
          params: {
            'matchId': _is.ParameterDescription(
              name: 'matchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'transport': _is.ParameterDescription(
              name: 'transport',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friendMatch'] as _i3eu9671.FriendMatchEndpoint)
                      .connected(
                        session,
                        params['matchId'],
                        params['transport'],
                      ),
        ),
        'leave': _is.MethodConnector(
          name: 'leave',
          params: {
            'matchId': _is.ParameterDescription(
              name: 'matchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friendMatch'] as _i3eu9671.FriendMatchEndpoint)
                      .leave(
                        session,
                        params['matchId'],
                      ),
        ),
        'claim': _is.MethodConnector(
          name: 'claim',
          params: {
            'matchId': _is.ParameterDescription(
              name: 'matchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'hostGoals': _is.ParameterDescription(
              name: 'hostGoals',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'guestGoals': _is.ParameterDescription(
              name: 'guestGoals',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'stats': _is.ParameterDescription(
              name: 'stats',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friendMatch'] as _i3eu9671.FriendMatchEndpoint)
                      .claim(
                        session,
                        params['matchId'],
                        params['hostGoals'],
                        params['guestGoals'],
                        params['reason'],
                        params['stats'],
                      ),
        ),
        'history': _is.MethodConnector(
          name: 'history',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friendMatch'] as _i3eu9671.FriendMatchEndpoint)
                      .history(
                        session,
                        params['limit'],
                      ),
        ),
      },
    );
    connectors['lobby'] = _is.EndpointConnector(
      name: 'lobby',
      endpoint: endpoints['lobby']!,
      methodConnectors: {
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'clientVersion': _is.ParameterDescription(
              name: 'clientVersion',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lobby'] as _ixxnzf3o.LobbyEndpoint).create(
                session,
                params['clientVersion'],
              ),
        ),
        'join': _is.MethodConnector(
          name: 'join',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'clientVersion': _is.ParameterDescription(
              name: 'clientVersion',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lobby'] as _ixxnzf3o.LobbyEndpoint).join(
                session,
                params['code'],
                params['clientVersion'],
              ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'lobbyId': _is.ParameterDescription(
              name: 'lobbyId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lobby'] as _ixxnzf3o.LobbyEndpoint).get(
                session,
                params['lobbyId'],
              ),
        ),
        'setNation': _is.MethodConnector(
          name: 'setNation',
          params: {
            'lobbyId': _is.ParameterDescription(
              name: 'lobbyId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'nationId': _is.ParameterDescription(
              name: 'nationId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['lobby'] as _ixxnzf3o.LobbyEndpoint).setNation(
                    session,
                    params['lobbyId'],
                    params['nationId'],
                  ),
        ),
        'setReady': _is.MethodConnector(
          name: 'setReady',
          params: {
            'lobbyId': _is.ParameterDescription(
              name: 'lobbyId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'ready': _is.ParameterDescription(
              name: 'ready',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['lobby'] as _ixxnzf3o.LobbyEndpoint).setReady(
                    session,
                    params['lobbyId'],
                    params['ready'],
                  ),
        ),
        'leave': _is.MethodConnector(
          name: 'leave',
          params: {
            'lobbyId': _is.ParameterDescription(
              name: 'lobbyId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['lobby'] as _ixxnzf3o.LobbyEndpoint).leave(
                session,
                params['lobbyId'],
              ),
        ),
        'rematch': _is.MethodConnector(
          name: 'rematch',
          params: {
            'lobbyId': _is.ParameterDescription(
              name: 'lobbyId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'clientVersion': _is.ParameterDescription(
              name: 'clientVersion',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['lobby'] as _ixxnzf3o.LobbyEndpoint).rematch(
                    session,
                    params['lobbyId'],
                    params['clientVersion'],
                  ),
        ),
      },
    );
    connectors['profile'] = _is.EndpointConnector(
      name: 'profile',
      endpoint: endpoints['profile']!,
      methodConnectors: {
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i6ky944g.ProfileEndpoint).me(
                session,
              ),
        ),
        'isNameAvailable': _is.MethodConnector(
          name: 'isNameAvailable',
          params: {
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i6ky944g.ProfileEndpoint)
                  .isNameAvailable(
                    session,
                    params['displayName'],
                  ),
        ),
        'createProfile': _is.MethodConnector(
          name: 'createProfile',
          params: {
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'acceptTerms': _is.ParameterDescription(
              name: 'acceptTerms',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i6ky944g.ProfileEndpoint)
                  .createProfile(
                    session,
                    params['displayName'],
                    params['acceptTerms'],
                  ),
        ),
        'updateProfile': _is.MethodConnector(
          name: 'updateProfile',
          params: {
            'region': _is.ParameterDescription(
              name: 'region',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'favouriteNation': _is.ParameterDescription(
              name: 'favouriteNation',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i6ky944g.ProfileEndpoint)
                  .updateProfile(
                    session,
                    params['region'],
                    params['favouriteNation'],
                  ),
        ),
        'record': _is.MethodConnector(
          name: 'record',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i6ky944g.ProfileEndpoint)
                  .record(session),
        ),
        'deleteAccount': _is.MethodConnector(
          name: 'deleteAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i6ky944g.ProfileEndpoint)
                  .deleteAccount(session),
        ),
      },
    );
    connectors['chat'] = _is.EndpointConnector(
      name: 'chat',
      endpoint: endpoints['chat']!,
      methodConnectors: {
        'send': _is.MethodConnector(
          name: 'send',
          params: {
            'lobbyId': _is.ParameterDescription(
              name: 'lobbyId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['chat'] as _ib6swwnz.ChatEndpoint).send(
                session,
                params['lobbyId'],
                params['text'],
              ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'lobbyId': _is.ParameterDescription(
              name: 'lobbyId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['chat'] as _ib6swwnz.ChatEndpoint).list(
                session,
                params['lobbyId'],
              ),
        ),
      },
    );
    connectors['friends'] = _is.EndpointConnector(
      name: 'friends',
      endpoint: endpoints['friends']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['friends'] as _iejqgreb.FriendsEndpoint)
                  .list(session),
        ),
        'request': _is.MethodConnector(
          name: 'request',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friends'] as _iejqgreb.FriendsEndpoint).request(
                    session,
                    params['name'],
                  ),
        ),
        'accept': _is.MethodConnector(
          name: 'accept',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friends'] as _iejqgreb.FriendsEndpoint).accept(
                    session,
                    params['userId'],
                  ),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friends'] as _iejqgreb.FriendsEndpoint).remove(
                    session,
                    params['userId'],
                  ),
        ),
        'block': _is.MethodConnector(
          name: 'block',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friends'] as _iejqgreb.FriendsEndpoint).block(
                    session,
                    params['userId'],
                  ),
        ),
        'unblock': _is.MethodConnector(
          name: 'unblock',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friends'] as _iejqgreb.FriendsEndpoint).unblock(
                    session,
                    params['userId'],
                  ),
        ),
        'invite': _is.MethodConnector(
          name: 'invite',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'lobbyId': _is.ParameterDescription(
              name: 'lobbyId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friends'] as _iejqgreb.FriendsEndpoint).invite(
                    session,
                    params['userId'],
                    params['lobbyId'],
                  ),
        ),
        'dismissInvite': _is.MethodConnector(
          name: 'dismissInvite',
          params: {
            'lobbyId': _is.ParameterDescription(
              name: 'lobbyId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['friends'] as _iejqgreb.FriendsEndpoint)
                  .dismissInvite(
                    session,
                    params['lobbyId'],
                  ),
        ),
      },
    );
    connectors['report'] = _is.EndpointConnector(
      name: 'report',
      endpoint: endpoints['report']!,
      methodConnectors: {
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'targetUserId': _is.ParameterDescription(
              name: 'targetUserId',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'matchId': _is.ParameterDescription(
              name: 'matchId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['report'] as _i5mkv7jo.ReportEndpoint).create(
                    session,
                    params['targetUserId'],
                    params['matchId'],
                    params['reason'],
                  ),
        ),
      },
    );
    connectors['tournament'] = _is.EndpointConnector(
      name: 'tournament',
      endpoint: endpoints['tournament']!,
      methodConnectors: {
        'current': _is.MethodConnector(
          name: 'current',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tournament'] as _i6ilfrpl.TournamentEndpoint)
                      .current(session),
        ),
        'start': _is.MethodConnector(
          name: 'start',
          params: {
            'nationId': _is.ParameterDescription(
              name: 'nationId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tournament'] as _i6ilfrpl.TournamentEndpoint)
                      .start(
                        session,
                        params['nationId'],
                      ),
        ),
        'abandon': _is.MethodConnector(
          name: 'abandon',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tournament'] as _i6ilfrpl.TournamentEndpoint)
                      .abandon(session),
        ),
        'submitResult': _is.MethodConnector(
          name: 'submitResult',
          params: {
            'tournamentId': _is.ParameterDescription(
              name: 'tournamentId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'fixtureId': _is.ParameterDescription(
              name: 'fixtureId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'nonce': _is.ParameterDescription(
              name: 'nonce',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'homeScore': _is.ParameterDescription(
              name: 'homeScore',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'awayScore': _is.ParameterDescription(
              name: 'awayScore',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'homePens': _is.ParameterDescription(
              name: 'homePens',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'awayPens': _is.ParameterDescription(
              name: 'awayPens',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'decidedBy': _is.ParameterDescription(
              name: 'decidedBy',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tournament'] as _i6ilfrpl.TournamentEndpoint)
                      .submitResult(
                        session,
                        params['tournamentId'],
                        params['fixtureId'],
                        params['nonce'],
                        params['homeScore'],
                        params['awayScore'],
                        params['homePens'],
                        params['awayPens'],
                        params['decidedBy'],
                      ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
