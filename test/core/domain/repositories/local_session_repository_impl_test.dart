import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/repositories/repositores.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late ILocalUserSessionRepository sut;

  late LocalSessionDatasourceSpy localSessionDatasource;

  late UserSessionModel sessionModel;

  void initSut() {
    sut = LocalUserSessionRepositoryImpl(localSessionDatasource);
  }

  void initInjections() {
    localSessionDatasource = LocalSessionDatasourceSpy();
  }

  void mockSuccess() {
    localSessionDatasource.mockSaveSession(sessionModel);
    localSessionDatasource.mockGetSession(sessionModel);
  }

  void initEntities() {
    sessionModel = UserSessionModel(baseUrl: faker.internet.httpUrl());
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test("Should behave correctly on save", () async {
    await sut.save(sessionModel);

    verify(() => localSessionDatasource.save(sessionModel)).called(1);
  });
  test("Should behave correctly on get", () async {
    expect(await sut.get(), sessionModel);

    verify(() => localSessionDatasource.get()).called(1);
  });
  test("Should on clear", () async {
    await sut.clear();

    verify(() => localSessionDatasource.clear()).called(1);
  });
}
