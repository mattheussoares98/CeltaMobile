import 'package:celta_intelligence/core/domain/entities/product/user_preferred_search_type.dart';
import 'package:celta_intelligence/core/domain/repositories/repositores.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late LocalPreferredSearchTypeRepository sut;

  late LocalPreferredSearchTypeDatasourceSpy localPreferredSearchTypeDatasource;

  late UserPreferredSearchType userPreferredSearchType;

  void initSut() {
    sut = LocalPreferredSearchTypeRepository(
      localPreferredSearchTypeDatasource,
    );
  }

  void initInjections() {
    localPreferredSearchTypeDatasource =
        LocalPreferredSearchTypeDatasourceSpy();
  }

  void mockSuccess() {
    localPreferredSearchTypeDatasource.mockLoadDefault(userPreferredSearchType);
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

  setUpAll(() {
    for (var value in UserPreferredSearchType.values) {
      registerFallbackValue(value);
    }
  });

  test("Should behave correctly on load default", () async {
    final value = await sut.loadDefault();

    expect(value, userPreferredSearchType);

    verify(() => localPreferredSearchTypeDatasource.loadDefault()).called(1);
  });
  test("Should behave correctly on change default", () async {
    await sut.changeDefault(userPreferredSearchType);

    verify(
      () => localPreferredSearchTypeDatasource.changeDefault(
        userPreferredSearchType,
      ),
    ).called(1);
  });
}
