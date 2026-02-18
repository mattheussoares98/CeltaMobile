import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/user_session/user_session.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/hive/hive.dart';
import 'package:celta_inventario/core/providers/user_session/user_session.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class UserSessionRepositorySpy extends Mock implements IUserSessionRepository {
  UserSessionRepositorySpy() {
    when(() => this.save(any())).thenAnswer((_) async => {});
    when(
      () => this.logout(
        userName: any(named: 'userName'),
        deviceType: any(named: 'deviceType'),
        enterpriseId: any(named: 'enterpriseId'),
      ),
    ).thenAnswer((_) async => {});
  }

  void mockGet(UserSessionModel? response) {
    when(() => this.get()).thenAnswer((_) async => response);
  }
}

void main() {
  late UserSessionRepositorySpy userSessionRepository;
  late SupabaseUserSessionDatasourceSpy supabaseUserSessionDatasource;
  late UserSessionModel userSession;
  late List<MockBox> mockBoxesToClearOnLogout;
  late DeviceType deviceType;

  setUp(() {
    userSessionRepository = UserSessionRepositorySpy();
    supabaseUserSessionDatasource = SupabaseUserSessionDatasourceSpy();
    userSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );

    mockBoxesToClearOnLogout = [MockBox(), MockBox(), MockBox()];

    registerFallbackValue(userSession);

    userSessionRepository.mockGet(userSession);
    deviceType = DeviceType
        .values[faker.randomGenerator.integer(DeviceType.values.length)];
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        userSessionRepositoryProvider.overrideWithValue(userSessionRepository),
        boxesToClearOnLogoutProvider.overrideWithValue(
          mockBoxesToClearOnLogout,
        ),
        supabaseUserSessionDatasourceProvider.overrideWithValue(
          supabaseUserSessionDatasource,
        ),
      ],
    );
  }

  setUpAll(() {
    registerFallbackValue(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );
    for (var value in DeviceType.values) {
      registerFallbackValue(value);
    }
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
          verify(() => userSessionRepository.get()).called(1);
        },
      );

      test('should return null when datasource.get returns null', () async {
        userSessionRepository.mockGet(null);

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
          userSessionRepository.mockGet(null);

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

          verify(() => userSessionRepository.save(userSession)).called(1);
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
          await container.read(userSessionProvider.notifier).logout(deviceType);

          // ASSERT
          expect(states, [
            isA<AsyncLoading>(),
            isA<AsyncData<UserSessionModel?>>(),
          ]);
          verify(
            () => userSessionRepository.logout(
              userName: userSession.user.name!,
              deviceType: deviceType,
              enterpriseId: userSession.enterprise!.id!,
            ),
          ).called(1);

          for (var box in mockBoxesToClearOnLogout) {
            verify(() => box.clear()).called(1);
          }
        },
      );
      test(
        'should not clear boxes if supabaseUserSessionDatasourceProvider fails',
        () async {
          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(userSessionProvider.future);
          when(
            () => userSessionRepository.logout(
              userName: any(named: 'userName'),
              deviceType: any(named: 'deviceType'),
              enterpriseId: any(named: 'enterpriseId'),
            ),
          ).thenThrow(Exception());

          // ACT
          await container.read(userSessionProvider.notifier).logout(deviceType);

          verify(
            () => userSessionRepository.logout(
              userName: userSession.user.name!,
              deviceType: deviceType,
              enterpriseId: userSession.enterprise!.id!,
            ),
          ).called(1);

          for (var box in mockBoxesToClearOnLogout) {
            verifyNever(() => box.clear());
          }
        },
      );
    });
  });
}
