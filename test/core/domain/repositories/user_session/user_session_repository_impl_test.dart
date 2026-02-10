import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/user_session/user_session.dart';
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
  }

  void initEntities() {
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    userName = faker.internet.userName();
    deviceType = DeviceType
        .values[faker.randomGenerator.integer(DeviceType.values.length)];
    enterpriseId = faker.randomGenerator.integer(100);
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
  test("Should on clear", () async {
    await sut.logout(
      userName: userName,
      deviceType: deviceType,
      enterpriseId: enterpriseId,
    );

    verify(
      () => supabaseUserSessionDatasource.removeUserSession(
        userName: userName,
        deviceType: deviceType,
        enterpriseId: enterpriseId,
      ),
    ).called(1);
    verify(() => localSessionDatasource.logout()).called(1);
  });
  test("Should on clear when supabase fails", () async {
    when(
      () => supabaseUserSessionDatasource.removeUserSession(
        userName: any(named: 'userName'),
        deviceType: any(named: 'deviceType'),
        enterpriseId: any(named: 'enterpriseId'),
      ),
    ).thenThrow(Exception());

    expect(
      sut.logout(
        userName: userName,
        deviceType: deviceType,
        enterpriseId: enterpriseId,
      ),
      throwsA(isA<Exception>()),
    );

    verify(
      () => supabaseUserSessionDatasource.removeUserSession(
        userName: userName,
        deviceType: deviceType,
        enterpriseId: enterpriseId,
      ),
    ).called(1);
    verifyNever(() => localSessionDatasource.logout());
  });
}
