import 'package:celta_intelligence/features/buy_request/data/models/models.dart';
import 'package:celta_intelligence/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/competing_prices/data/models/models.dart';
import 'package:celta_intelligence/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_intelligence/features/competing_prices/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapLoadResearchsDatasourceSpy extends Mock
    implements ISoapLoadResearchsDatasource {
  void mockLoad(List<ResearchModel> response) {
    when(
      () => this.load(
        crossIdentity: any(named: 'crossIdentity'),
        baseUrl: any(named: 'baseUrl'),
        enterpriseCode: any(named: 'enterpriseCode'),
        searchValue: any(named: 'searchValue'),
      ),
    ).thenAnswer((_) async => response);
  }
}

void main() {
  late ISoapLoadResearchsRepository sut;

  late SoapLoadResearchsDatasourceSpy datasource;

  late List<ResearchEntity> researchEntities;
  late String searchValue;
  late String crossIdentity;
  late String baseUrl;
  late int enterpriseCode;

  void initSut() {
    sut = SoapLoadResearchsRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadResearchsDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(
      researchEntities.map((e) => ResearchModel.fromEntity(e)).toList(),
    );
  }

  void initEntities() {
    researchEntities = [
      EntityFactory.makeResearchEntity(),
      EntityFactory.makeResearchEntity(),
      EntityFactory.makeResearchEntity(),
    ];
    searchValue = faker.randomGenerator.boolean()
        ? faker.randomGenerator.integer(100).toString()
        : faker.lorem.word();
    crossIdentity = faker.guid.guid();
    baseUrl = faker.internet.httpUrl();
    enterpriseCode = faker.randomGenerator.integer(1000);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(
      PendingBuyRequestModel.fromEntity(
        EntityFactory.makePendingBuyRequestEntity(),
      ),
    );
  });

  test(
    'should behave correctly on success without passing searchValue',
    () async {
      final response = await sut.load(
        crossIdentity: crossIdentity,
        baseUrl: baseUrl,
        enterpriseCode: enterpriseCode,
      );

      expect(response, researchEntities);

      verify(
        () => datasource.load(
          crossIdentity: crossIdentity,
          baseUrl: baseUrl,
          enterpriseCode: enterpriseCode,
          searchValue: null,
        ),
      ).called(1);

      verifyNoMoreInteractions(datasource);
    },
  );
  test('should behave correctly on success passing searchValue', () async {
    final response = await sut.load(
      crossIdentity: crossIdentity,
      baseUrl: baseUrl,
      enterpriseCode: enterpriseCode,
      searchValue: searchValue,
    );

    expect(response, researchEntities);

    verify(
      () => datasource.load(
        crossIdentity: crossIdentity,
        baseUrl: baseUrl,
        enterpriseCode: enterpriseCode,
        searchValue: searchValue,
      ),
    ).called(1);

    verifyNoMoreInteractions(datasource);
  });
}
