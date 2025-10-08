import 'package:celta_intelligence/features/customer_register/data/models/models.dart';
import 'package:celta_intelligence/features/customer_register/domain/entities/entities.dart';
import 'package:celta_intelligence/features/customer_register/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadCovenantsRepository sut;

  late SoapLoadCovenantsDatasourceSpy datasource;

  late List<CovenantEntity> covenantEntities;
  late String baseUrl;
  late String crossIdentity;
  late SearchCovenantType searchCovenantType;
  late String searchValue;

  void initSut() {
    sut = SoapLoadCovenantsRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadCovenantsDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(
      covenantEntities.map((e) => CovenantModel.fromEntity(e)).toList(),
    );
  }

  void initEntities() {
    covenantEntities = [
      EntityFactory.makeCovenantEntity(),
      EntityFactory.makeCovenantEntity(),
      EntityFactory.makeCovenantEntity(),
    ];
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    searchCovenantType =
        SearchCovenantType.values[faker.randomGenerator.integer(
          SearchCovenantType.values.length,
        )];
    searchValue = faker.guid.guid();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeUserEntity());
    for (var value in SearchCovenantType.values) {
      registerFallbackValue(value);
    }
  });

  group('Load Covenants', () {
    test('should behave correctly on success', () async {
      final covenants = await sut.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        searchCovenantType: searchCovenantType,
        searchValue: searchValue,
      );

      expect(covenants, covenantEntities);
      verify(
        () => datasource.load(
          baseUrl: baseUrl,
          crossIdentity: crossIdentity,
          searchCovenantType: searchCovenantType,
          searchValue: searchValue,
        ),
      ).called(1);

      verifyNoMoreInteractions(datasource);
    });
  });
}
