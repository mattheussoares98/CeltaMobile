import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/user_session/user_session.dart';
import 'package:celta_inventario/core/data/repositories/user_session/user_session.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IUserSessionRepository sut;

  late LocalUserSessionDatasourceSpy localSessionDatasource;
  late SupabaseUserSessionDatasourceSpy supabaseUserSessionDatasource;

  late UserSessionEntity userSessionEntity;

  late String userName;
  late DeviceType deviceType;
  late int enterpriseId;
  late String? fcmToken;
  late String appVersion;
  late String installationId;

  void initSut() {
    sut = UserSessionRepositoryImpl(
      localSessionDatasource,
      supabaseUserSessionDatasource,
    );
  }

  void initInjections() {
    localSessionDatasource = LocalUserSessionDatasourceSpy();
    supabaseUserSessionDatasource = SupabaseUserSessionDatasourceSpy();
  }

  void mockSuccess() {
    localSessionDatasource.mockGetSession(
      UserSessionModel.fromEntity(userSessionEntity),
    );
    localSessionDatasource.mockInstallationId(installationId);
  }

  void initEntities() {
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    userName = faker.internet.userName();
    deviceType = DeviceType
        .values[faker.randomGenerator.integer(DeviceType.values.length)];
    enterpriseId = faker.randomGenerator.integer(100);
    fcmToken = faker.guid.guid();
    appVersion = faker.lorem.word();
    installationId = faker.guid.guid();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );
    for (var value in DeviceType.values) {
      registerFallbackValue(value);
    }
  });

  test("Should behave correctly on save", () async {
    await sut.save(UserSessionModel.fromEntity(userSessionEntity));

    verify(
      () => localSessionDatasource.save(
        UserSessionModel.fromEntity(userSessionEntity),
      ),
    ).called(1);
  });
  test("Should behave correctly on get", () async {
    expect(await sut.get(), UserSessionModel.fromEntity(userSessionEntity));

    verify(() => localSessionDatasource.get()).called(1);
  });

  test("Should synchronize the remote session", () async {
    await sut.synchronizeRemoteSession(
      userName: userName,
      deviceType: deviceType,
      enterpriseId: enterpriseId,
      fcmToken: fcmToken,
      appVersion: appVersion,
    );

    verify(() => localSessionDatasource.getOrCreateInstallationId()).called(1);
    verify(
      () => supabaseUserSessionDatasource.handleUserSession(
        userName: userName,
        deviceType: deviceType,
        firebaseEnterpriseId: enterpriseId,
        fcmToken: fcmToken,
        appVersion: appVersion,
        installationId: installationId,
      ),
    ).called(1);
  });

  test("Should on clear", () async {
    await sut.logout();

    verify(
      () => supabaseUserSessionDatasource.removeUserSession(
        installationId: installationId,
      ),
    ).called(1);
    verify(() => localSessionDatasource.getOrCreateInstallationId()).called(1);
    verify(() => localSessionDatasource.logout()).called(1);
  });
  test("Should on clear when supabase fails", () async {
    when(
      () => supabaseUserSessionDatasource.removeUserSession(
        installationId: installationId,
      ),
    ).thenThrow(Exception());

    await sut.logout();

    verify(
      () => supabaseUserSessionDatasource.removeUserSession(
        installationId: installationId,
      ),
    ).called(1);
    verify(() => localSessionDatasource.logout()).called(1);
  });
}
