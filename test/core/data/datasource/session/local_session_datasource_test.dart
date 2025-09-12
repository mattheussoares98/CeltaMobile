import 'package:celta_intelligence/core/constants/database_keys.dart';
import 'package:celta_intelligence/core/data/datasource/datasource.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late LocalSessionDataSource sut;

  late MockBox hive;

  late SessionModel sessionModel;

  void initSut() {
    sut = LocalSessionDataSource(hive);
  }

  void initInjections() {
    hive = MockBox();
  }

  void mockSuccess() {
    hive.mockGet(DatabaseKeys.session.name, sessionModel.toJson());
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

  group('clear', () {
    test('Should call hive with correct params', () async {
      await sut.clear();

      verify(() => hive.delete(DatabaseKeys.session.name)).called(1);
    });
  });
  group('Get', () {
    test('Should behave correctly', () async {
      expect(await sut.get(), sessionModel);

      verify(() => hive.get(DatabaseKeys.session.name)).called(1);
    });

    test('Should return null if hive returns null', () async {
      hive.mockGet(DatabaseKeys.session.name, null);

      expect(await sut.get(), isNull);
    });
  });

  group("Save", () {
    test("Should call hive with correct params", () async {
      await sut.save(sessionModel);

      verify(
        () => hive.put(DatabaseKeys.session.name, sessionModel.toJson()),
      ).called(1);
    });
  });
}
