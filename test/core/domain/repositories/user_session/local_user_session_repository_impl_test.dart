import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/user_session/user_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalUserSessionRepository sut;

  late LocalUserSessionDatasourceSpy localSessionDatasource;

  late UserSessionEntity userSessionEntity;

  void initSut() {
    sut = LocalUserSessionRepositoryImpl(localSessionDatasource);
  }

  void initInjections() {
    localSessionDatasource = LocalUserSessionDatasourceSpy();
  }

  void mockSuccess() {
    localSessionDatasource.mockGetSession(
      UserSessionModel.fromEntity(userSessionEntity),
    );
  }

  void initEntities() {
    userSessionEntity = EntityFactory.makeUserSessionEntity();
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
    await sut.logout();

    verify(() => localSessionDatasource.logout()).called(1);
  });
}
