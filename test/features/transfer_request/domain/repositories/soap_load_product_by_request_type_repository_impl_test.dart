import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/transfer_request/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/transfer_request/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapLoadProductByRequestTypeDatasourceSpy extends Mock
    implements ISoapLoadProductByRequestTypeDatasource {
  void mockLoad(List<ProductModel> response) {
    when(
      () => this.load(
        baseUrl: any(named: 'baseUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        enterpriseOriginCode: any(named: 'enterpriseOriginCode'),
        enterpriseDestinyCode: any(named: 'enterpriseDestinyCode'),
        requestTypeCode: any(named: 'requestTypeCode'),
        searchValue: any(named: 'searchValue'),
        enterpriseEntity: any(named: 'enterpriseEntity'),
        searchType: any(named: 'searchType'),
      ),
    ).thenAnswer((_) async => response);
  }
}

void main() {
  late ISoapLoadProductByRequestTypeRepository sut;

  late SoapLoadProductByRequestTypeDatasourceSpy datasource;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseOriginCode;
  late int requestTypeCode;
  late int enterpriseDestinyCode;
  late String searchValue;
  late EnterpriseEntity enterpriseEntity;
  late SearchType searchType;

  late List<ProductEntity> productsEntities;

  void initSut() {
    sut = SoapLoadProductByRequestTypeRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadProductByRequestTypeDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(
      productsEntities.map((e) => ProductModel.fromEntity(e)).toList(),
    );
  }

  void initEntities() {
    baseUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    enterpriseOriginCode = faker.randomGenerator.integer(1000);
    requestTypeCode = faker.randomGenerator.integer(1000);

    productsEntities = [
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
    ].map((e) => ProductModel.fromEntity(e).toEntity()).toList();

    enterpriseDestinyCode = faker.randomGenerator.integer(1000);
    searchValue = faker.lorem.word();
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    searchType = SearchType
        .values[faker.randomGenerator.integer(SearchType.values.length)];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });
  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
    for (var value in SearchType.values) {
      registerFallbackValue(value);
    }
  });

  test('should behave correctly on success', () async {
    final response = await sut.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseOriginCode: enterpriseOriginCode,
      requestTypeCode: requestTypeCode,
      enterpriseDestinyCode: enterpriseDestinyCode,
      searchValue: searchValue,
      enterpriseEntity: enterpriseEntity,
      searchType: searchType,
    );

    expect(response, productsEntities);

    verify(
      () => datasource.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        enterpriseOriginCode: enterpriseOriginCode,
        enterpriseDestinyCode: enterpriseDestinyCode,
        requestTypeCode: requestTypeCode,
        searchValue: searchValue,
        enterpriseEntity: enterpriseEntity,
        searchType: searchType,
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
