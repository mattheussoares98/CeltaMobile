import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/repositories/repositores.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late ILocalSessionRepository sut;

  late LocalSessionDataSourceSpy localSessionDataSource;

  late SessionModel sessionModel;

  void initSut() {
    sut = LocalSessionRepositoryImpl(localSessionDataSource);
  }

  void initInjections() {
    localSessionDataSource = LocalSessionDataSourceSpy();
  }

  void mockSuccess() {
    localSessionDataSource.mockSaveSession(sessionModel);
    localSessionDataSource.mockGetSession(sessionModel);
  }

  void initEntities() {
    sessionModel = SessionModel(baseUrl: faker.internet.httpUrl());
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test("Should behave correctly on save", () async {
    await sut.save(sessionModel);

    verify(() => localSessionDataSource.save(sessionModel)).called(1);
  });
  test("Should behave correctly on get", () async {
    expect(await sut.get(), sessionModel);

    verify(() => localSessionDataSource.get()).called(1);
  });
  test("Should on clear", () async {
    await sut.clear();

    verify(() => localSessionDataSource.clear()).called(1);
  });
}
