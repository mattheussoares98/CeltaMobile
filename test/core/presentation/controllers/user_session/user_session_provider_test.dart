import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/hive/hive.dart';
import 'package:celta_intelligence/core/providers/user_session/user_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late LocalUserSessionDatasourceSpy localUserSessionDatasource;
  late UserSessionModel userSession;
  late List<MockBox> mockBoxesToClearOnLogout;

  setUp(() {
    localUserSessionDatasource = LocalUserSessionDatasourceSpy();
    userSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );

    mockBoxesToClearOnLogout = [MockBox(), MockBox(), MockBox()];

    registerFallbackValue(userSession);

    localUserSessionDatasource.mockGetSession(userSession);
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        localUserSessionDatasourceProvider.overrideWithValue(
          localUserSessionDatasource,
        ),
        boxesToClearOnLogoutProvider.overrideWithValue(
          mockBoxesToClearOnLogout,
        ),
      ],
    );
  }

  setUpAll(() {
    registerFallbackValue(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );
  });

  group('UserSession Controller', () {
    group('build', () {
      test(
        'should call datasource.get and return a session on success',
        () async {
          final container = makeProviderContainer();
          addTearDown(container.dispose);

          // ACT: Wait for the build method to complete
          final result = await container.read(userSessionProvider.future);

          // ASSERT
          expect(result, userSession);
          verify(() => localUserSessionDatasource.get()).called(1);
        },
      );

      test('should return null when datasource.get returns null', () async {
        localUserSessionDatasource.mockGetSession(null);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(userSessionProvider.future);

        // ASSERT
        expect(result, isNull);
      });
    });

    group('saveSession', () {
      test(
        'should emit [loading, data] and call datasource.save on success',
        () async {
          localUserSessionDatasource.mockGetSession(null);

          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(
            userSessionProvider.future,
          ); // Wait for initial build

          final states = <AsyncValue<UserSessionModel?>>[];
          container.listen(userSessionProvider, (_, next) => states.add(next));

          // ACT
          await container
              .read(userSessionProvider.notifier)
              .saveSession(userSession);

          // ASSERT
          expect(states, [
            isA<AsyncLoading>(),
            isA<AsyncData<UserSessionModel?>>(),
          ]);

          verify(() => localUserSessionDatasource.save(userSession)).called(1);
        },
      );
    });

    group('logout', () {
      test(
        'should emit [loading, data(null)] and call datasource.clear on success',
        () async {
          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(userSessionProvider.future);

          final states = <AsyncValue<UserSessionModel?>>[];
          container.listen(userSessionProvider, (_, next) => states.add(next));

          // ACT
          await container.read(userSessionProvider.notifier).logout();

          // ASSERT
          expect(states, [
            isA<AsyncLoading>(),
            isA<AsyncData<UserSessionModel?>>(),
          ]);
          verify(() => localUserSessionDatasource.logout()).called(1);

          for (var box in mockBoxesToClearOnLogout) {
            verify(() => box.clear()).called(1);
          }
        },
      );
    });
  });
}
