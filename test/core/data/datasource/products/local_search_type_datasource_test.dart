import 'package:celta_intelligence/core/constants/database_keys.dart';
import 'package:celta_intelligence/core/data/datasource/datasource.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late LocalSearchTypeDatasource sut;

  late MockBox hive;

  late UserPreferredSearchType userPreferredSearchType;

  void initSut() {
    sut = LocalSearchTypeDatasource(hive);
  }

  void initInjections() {
    hive = MockBox();
  }

  void mockSuccess() {
    hive.mockGet(
      DatabaseKeys.userPeferredSearchTypeProducts.name,
      userPreferredSearchType.name,
    );
  }

  void initEntities() {
    userPreferredSearchType =
        UserPreferredSearchType.values[faker.randomGenerator.integer(
          UserPreferredSearchType.values.length,
        )];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Change default', () {
    test('Should call hive with correct params', () async {
      await sut.changeDefault(userPreferredSearchType);

      verify(
        () => hive.put(
          DatabaseKeys.userPeferredSearchTypeProducts.name,
          userPreferredSearchType.name,
        ),
      ).called(1);
    });
  });
  group('Get', () {
    test('Should return correct value when is not null', () async {
      expect(await sut.loadDefault(), userPreferredSearchType);

      verify(
        () => hive.get(DatabaseKeys.userPeferredSearchTypeProducts.name),
      ).called(1);
    });

    test('Should return correct value when returns null', () async {
      hive.mockGet(DatabaseKeys.userPeferredSearchTypeProducts.name, null);

      expect(await sut.loadDefault(), UserPreferredSearchType.dynamic);
    });
  });
}
