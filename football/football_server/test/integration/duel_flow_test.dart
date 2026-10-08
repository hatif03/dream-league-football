import 'package:test/test.dart';

import 'package:football_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Drives the real endpoints against a real database (Serverpod's `withServerpod` rolls every test back):
/// matchmaking pairs two players, the server referees a penalty duel and moves Elo ratings.
void main() {
  withServerpod('Given two signed-in players', (sessionBuilder, endpoints) {
    late TestSessionBuilder a, b;

    setUp(() async {
      final session = sessionBuilder.build();
      Future<TestSessionBuilder> player(String id, String name) async {
        await UserProfile.db.insertRow(
          session,
          UserProfile(userId: id, displayName: name, displayNameLower: name.toLowerCase()),
        );
        return sessionBuilder.copyWith(authentication: AuthenticationOverride.authenticationInfo(id, {}));
      }

      a = await player('00000000-0000-0000-0000-00000000000a', 'Ann');
      b = await player('00000000-0000-0000-0000-00000000000b', 'Bob');
    });

    test('when both join the penalties queue then they are paired into a live duel', () async {
      final first = await endpoints.matchmaking.join(a, 'penalties', 'build-1');
      expect(first.searching, isTrue);
      final second = await endpoints.matchmaking.join(b, 'penalties', 'build-1');
      expect(second.lobby, isNotNull);
      expect(second.lobby!.lobby.status, 'live');
      expect(second.lobby!.lobby.mode, 'penalties');
    });

    test('when players are on different builds then they are not paired', () async {
      await endpoints.matchmaking.join(a, 'penalties', 'build-1');
      final other = await endpoints.matchmaking.join(b, 'penalties', 'build-2');
      expect(other.lobby, isNull);
      expect(other.searching, isTrue);
    });

    test('when a duel is played to the end then there is a winner and the ratings move equally and oppositely', () async {
      await endpoints.matchmaking.join(a, 'penalties', 'build-1');
      final paired = await endpoints.matchmaking.join(b, 'penalties', 'build-1');
      final matchId = paired.lobby!.lobby.matchId!;

      var view = await endpoints.penalty.state(a, matchId);
      var guard = 0;
      while (view.status == 'live' && guard++ < 60) {
        await endpoints.penalty.submit(a, matchId, view.seq, 1);
        view = await endpoints.penalty.submit(b, matchId, view.seq, 4);
        view = await endpoints.penalty.state(a, matchId);
      }
      expect(view.status, 'finished');
      expect(view.hostGoals, isNot(view.guestGoals));

      final session = sessionBuilder.build();
      final ra = (await UserProfile.db.findFirstRow(session, where: (p) => p.displayName.equals('Ann')))!.rating;
      final rb = (await UserProfile.db.findFirstRow(session, where: (p) => p.displayName.equals('Bob')))!.rating;
      expect(ra + rb, 2000, reason: 'Elo is zero-sum');
      expect(ra, isNot(1000));
    });

    test('when a stranger asks for the duel then it is not found', () async {
      await endpoints.matchmaking.join(a, 'penalties', 'build-1');
      final paired = await endpoints.matchmaking.join(b, 'penalties', 'build-1');
      final stranger = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo('00000000-0000-0000-0000-00000000000c', {}),
      );
      await expectLater(
        endpoints.penalty.state(stranger, paired.lobby!.lobby.matchId!),
        throwsA(isA<GameException>()),
      );
    });

    test('when asking for today\'s challenge then it has a target and no progress yet', () async {
      final c = await endpoints.challenges.today(a);
      expect(c.target, greaterThan(0));
      expect(c.progress, 0);
      expect(c.done, isFalse);
    });
  });
}
