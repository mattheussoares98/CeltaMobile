import 'dart:async';

import 'package:celta_inventario/core/data/datasource/notification/notification.dart'
    show INotificationDatasource;
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/user_session/user_session.dart';
import 'package:celta_inventario/core/presentation/controllers/app_version/app_version.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/hive/hive.dart';
import 'package:celta_inventario/core/providers/notification/notification.dart';
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
      () => this.synchronizeRemoteSession(
        userName: any(named: 'userName'),
        deviceType: any(named: 'deviceType'),
        enterpriseId: any(named: 'enterpriseId'),
        fcmToken: any(named: 'fcmToken'),
        appVersion: any(named: 'appVersion'),
      ),
    ).thenAnswer((_) async => {});
    when(() => this.logout()).thenAnswer((_) async => {});
  }

  void mockGet(UserSessionModel? response) {
    when(() => this.get()).thenAnswer((_) async => response);
  }
}

class NotificationDatasourceSpy extends Mock
    implements INotificationDatasource {}

class FakeAppVersion extends AppVersionStateController {
  final String appVersion;

  FakeAppVersion(this.appVersion);
  @override
  FutureOr<String> build() async {
    return appVersion;
  }
}

void main() {
  late UserSessionRepositorySpy userSessionRepository;
  late NotificationDatasourceSpy notificationDatasource;
  late StreamController<String> tokenRefreshController;

  late UserSessionModel userSession;
  late List<MockBox> mockBoxesToClearOnLogout;
  late String appVersion;
  late String initialFcmToken;

  setUp(() {
    userSessionRepository = UserSessionRepositorySpy();
    notificationDatasource = NotificationDatasourceSpy();
    tokenRefreshController = StreamController<String>.broadcast();
    addTearDown(tokenRefreshController.close);

    userSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    appVersion = faker.lorem.word();
    initialFcmToken = faker.guid.guid();

    mockBoxesToClearOnLogout = [MockBox(), MockBox(), MockBox()];

    registerFallbackValue(userSession);

    userSessionRepository.mockGet(userSession);
    when(
      () => notificationDatasource.getToken(),
    ).thenAnswer((_) async => initialFcmToken);
    when(
      () => notificationDatasource.onTokenRefresh,
    ).thenAnswer((_) => tokenRefreshController.stream);
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        userSessionRepositoryProvider.overrideWithValue(userSessionRepository),
        boxesToClearOnLogoutProvider.overrideWithValue(
          mockBoxesToClearOnLogout,
        ),
        appVersionStateControllerProvider.overrideWith(
          () => FakeAppVersion(appVersion),
        ),
        notificationDatasourceProvider.overrideWithValue(
          notificationDatasource,
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
      test('should save session with correct parameters', () async {
        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT
        await container.read(userSessionProvider.future);

        //!in the controller is not waiting call this method. But here, needs to wait
        await untilCalled(
          () => userSessionRepository.synchronizeRemoteSession(
            userName: userSession.user.name!,
            deviceType: deviceType,
            enterpriseId: userSession.enterprise!.id!,
            fcmToken: initialFcmToken,
            appVersion: appVersion,
          ),
        );
        // ASSERT
        verify(
          () => userSessionRepository.synchronizeRemoteSession(
            enterpriseId: userSession.enterprise!.id!,
            userName: userSession.user.name!,
            deviceType: deviceType,
            fcmToken: initialFcmToken,
            appVersion: appVersion,
          ),
        ).called(1);
      });

      test('should synchronize when the FCM token refreshes', () async {
        final refreshedFcmToken = faker.guid.guid();
        final container = makeProviderContainer();
        addTearDown(container.dispose);

        await container.read(userSessionProvider.future);
        await untilCalled(
          () => userSessionRepository.synchronizeRemoteSession(
            userName: userSession.user.name!,
            deviceType: deviceType,
            enterpriseId: userSession.enterprise!.id!,
            fcmToken: initialFcmToken,
            appVersion: appVersion,
          ),
        );
        clearInteractions(userSessionRepository);

        tokenRefreshController.add(refreshedFcmToken);

        await untilCalled(
          () => userSessionRepository.synchronizeRemoteSession(
            userName: userSession.user.name!,
            deviceType: deviceType,
            enterpriseId: userSession.enterprise!.id!,
            fcmToken: refreshedFcmToken,
            appVersion: appVersion,
          ),
        );
        verify(
          () => userSessionRepository.synchronizeRemoteSession(
            userName: userSession.user.name!,
            deviceType: deviceType,
            enterpriseId: userSession.enterprise!.id!,
            fcmToken: refreshedFcmToken,
            appVersion: appVersion,
          ),
        ).called(1);
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
          await container.read(userSessionProvider.notifier).logout();

          // ASSERT
          expect(states, [
            isA<AsyncLoading>(),
            isA<AsyncData<UserSessionModel?>>(),
          ]);
          verify(() => userSessionRepository.logout()).called(1);

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
          when(() => userSessionRepository.logout()).thenThrow(Exception());

          // ACT
          await container.read(userSessionProvider.notifier).logout();

          verify(() => userSessionRepository.logout()).called(1);

          for (var box in mockBoxesToClearOnLogout) {
            verifyNever(() => box.clear());
          }
        },
      );
    });
  });
}
