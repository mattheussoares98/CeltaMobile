import 'package:celta_intelligence/core/data/datasource/products/products.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/products/products.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapGetProductsJsonDatasourceSpy extends Mock
    implements ISoapGetProductsJsonDatasource {
  void mockGetProductsJson(List<ProductModel> response) {
    _mockCall().thenAnswer((_) async => response);
  }

  When _mockCall() => when(
    () => this.get(
      baseUrl: any(named: 'baseUrl'),
      parametersPayload: any(named: 'parametersPayload'),
      isCompetingPrices: any(named: 'isCompetingPrices'),
    ),
  );

  void mockError() {
    _mockCall().thenThrow(Exception());
  }
}

class SoapInventoryLoadProductsDatasourceSpy extends Mock
    implements ISoapInventoryLoadProductsDatasource {
  void mockGetInventoryProducts(List<InventoryProductModel> response) {
    _mockCall().thenAnswer((_) async => response);
  }

  When _mockCall() => when(
    () => this.get(
      baseUrl: any(named: 'baseUrl'),
      parametersPayload: any(named: 'parametersPayload'),
    ),
  );

  void mockError() {
    _mockCall().thenThrow(Exception());
  }
}

void main() {
  late ISoapLoadProductsRepository sut;

  late SoapGetProductsJsonDatasourceSpy soapProductsDatasource;
  late SoapInventoryLoadProductsDatasourceSpy soapInventoryDatasource;

  late List<ProductEntity> jsonProductsEntities;
  late List<ProductEntity> inventoryProductsEntities;
  late String baseUrl;
  late String crossIdentity;
  late EnterpriseEntity enterpriseEntity;
  late GetProductsJsonParams getProductsJsonParams;
  late GetProductsInventoryParams getProductsInventoryParams;

  void initSut() {
    sut = SoapLoadProductsRepositoryImpl(
      soapProductsDatasource,
      soapInventoryDatasource,
    );
  }

  void initInjections() {
    soapProductsDatasource = SoapGetProductsJsonDatasourceSpy();
    soapInventoryDatasource = SoapInventoryLoadProductsDatasourceSpy();
  }

  void mockSuccess() {
    soapProductsDatasource.mockGetProductsJson(
      jsonProductsEntities.map((e) => ProductModel.fromEntity(e)).toList(),
    );
    soapInventoryDatasource.mockGetInventoryProducts(
      inventoryProductsEntities
          .map((e) => InventoryProductModel.fromEntity(e))
          .toList(),
    );
  }

  void initEntities() {
    jsonProductsEntities = [
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
    ];
    baseUrl = faker.internet.httpUrl();
    getProductsJsonParams = GetProductsJsonParams(
      searchValue: faker.randomGenerator.string(13),
      EnterpriseCodes: [
        faker.randomGenerator.integer(100, min: 0),
        faker.randomGenerator.integer(200, min: 101),
        faker.randomGenerator.integer(300, min: 201),
      ],
      searchType: SearchType
          .values[faker.randomGenerator.integer(SearchType.values.length)],
      routine: BsRoutine
          .values[faker.randomGenerator.integer(BsRoutine.values.length)],
      LastBuyEntranceQuantity: faker.randomGenerator.integer(100),
      buyRequestParams: BuyRequestParams(
        requestTypeCode: faker.randomGenerator.integer(100),
        supplierCode: faker.randomGenerator.integer(100),
      ),
      competingPricesParams: CompetingPricesParams(
        ResearchOfPriceCode: faker.randomGenerator.integer(100),
        ConcurrentCode: faker.randomGenerator.integer(100),
        OnlyAssociated: faker.randomGenerator.boolean(),
        searchType:
            SearchProductCompetingPriceType.values[faker.randomGenerator
                .integer(SearchProductCompetingPriceType.values.length)],
      ),
    );
    crossIdentity = faker.guid.guid();
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    getProductsInventoryParams = GetProductsInventoryParams(
      searchValue: faker.lorem.word(),
      searchType: SearchType
          .values[faker.randomGenerator.integer(SearchType.values.length)],
      inventoryProcessCode: faker.randomGenerator.integer(100),
      inventoryCountingCode: faker.randomGenerator.integer(100),
    );
    inventoryProductsEntities = [
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });
  setUpAll(() {
    for (var routine in BsRoutine.values) {
      registerFallbackValue(routine);
    }
    for (var searchType in SearchType.values) {
      registerFallbackValue(searchType);
    }
    for (var value in SearchProductCompetingPriceType.values) {
      registerFallbackValue(value);
    }
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
  });

  group("Products json datasource", () {
    test("Should behave correctly when pass all params", () async {
      final response = await sut.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        enterpriseEntity: enterpriseEntity,
        getProductsDefaultParams: getProductsJsonParams,
      );

      expect(response, jsonProductsEntities);

      verify(
        () => soapProductsDatasource.get(
          baseUrl: baseUrl,
          isCompetingPrices: true,
          parametersPayload: {
            "CrossIdentity": crossIdentity,
            "EnterpriseCodes": getProductsJsonParams.EnterpriseCodes,
            "SearchValue": getProductsJsonParams.searchValue,
            "SearchType": getProductsJsonParams.searchType.code,
            "RoutineInt": getProductsJsonParams.routine.code,
            "LastBuyEntranceQuantity":
                getProductsJsonParams.LastBuyEntranceQuantity ?? 5,
            "RequestTypeCode":
                getProductsJsonParams.buyRequestParams!.requestTypeCode,
            "SupplierCode":
                getProductsJsonParams.buyRequestParams!.supplierCode,
            "SearchTypeInt": getProductsJsonParams.searchType.code,
            "ResearchOfPriceFilters": {
              "ResearchOfPriceCode": getProductsJsonParams
                  .competingPricesParams!
                  .ResearchOfPriceCode,
              "ConcurrentCode":
                  getProductsJsonParams.competingPricesParams!.ConcurrentCode,
              "OnlyAssociated":
                  getProductsJsonParams.competingPricesParams!.OnlyAssociated,
              "InformedPrices":
                  getProductsJsonParams.competingPricesParams!.searchType.code,
            },
          },
        ),
      ).called(1);
    });
    test("Should behave correctly when doesnt pass buyRequestParams", () async {
      final response = await sut.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        enterpriseEntity: enterpriseEntity,
        getProductsDefaultParams: getProductsJsonParams.annulValues(
          buyRequestParams: true,
        ),
      );

      expect(response, jsonProductsEntities);

      verify(
        () => soapProductsDatasource.get(
          baseUrl: baseUrl,
          isCompetingPrices: true,
          parametersPayload: {
            "CrossIdentity": crossIdentity,
            "EnterpriseCodes": getProductsJsonParams.EnterpriseCodes,
            "SearchValue": getProductsJsonParams.searchValue,
            "SearchType": getProductsJsonParams.searchType.code,
            "RoutineInt": getProductsJsonParams.routine.code,
            "LastBuyEntranceQuantity":
                getProductsJsonParams.LastBuyEntranceQuantity ?? 5,
            "SearchTypeInt": getProductsJsonParams.searchType.code,
            "ResearchOfPriceFilters": {
              "ResearchOfPriceCode": getProductsJsonParams
                  .competingPricesParams!
                  .ResearchOfPriceCode,
              "ConcurrentCode":
                  getProductsJsonParams.competingPricesParams!.ConcurrentCode,
              "OnlyAssociated":
                  getProductsJsonParams.competingPricesParams!.OnlyAssociated,
              "InformedPrices":
                  getProductsJsonParams.competingPricesParams!.searchType.code,
            },
          },
        ),
      ).called(1);
    });

    test(
      "Should behave correctly when doesnt pass competingPricesParams",
      () async {
        final response = await sut.load(
          baseUrl: baseUrl,
          crossIdentity: crossIdentity,
          enterpriseEntity: enterpriseEntity,
          getProductsDefaultParams: getProductsJsonParams.annulValues(
            competingPricesParams: true,
          ),
        );

        expect(response, jsonProductsEntities);

        verify(
          () => soapProductsDatasource.get(
            baseUrl: baseUrl,
            isCompetingPrices: false,
            parametersPayload: {
              "CrossIdentity": crossIdentity,
              "EnterpriseCodes": getProductsJsonParams.EnterpriseCodes,
              "SearchValue": getProductsJsonParams.searchValue,
              "SearchType": getProductsJsonParams.searchType.code,
              "RoutineInt": getProductsJsonParams.routine.code,
              "LastBuyEntranceQuantity":
                  getProductsJsonParams.LastBuyEntranceQuantity ?? 5,
              "RequestTypeCode":
                  getProductsJsonParams.buyRequestParams!.requestTypeCode,
              "SupplierCode":
                  getProductsJsonParams.buyRequestParams!.supplierCode,
            },
          ),
        ).called(1);
      },
    );

    test(
      "Should search again when is balance code and fails the first time",
      () async {
        soapProductsDatasource.mockError();

        const balanceEan = '2000000000000';

        try {
          final response = await sut.load(
            baseUrl: baseUrl,
            crossIdentity: crossIdentity,
            enterpriseEntity: enterpriseEntity,
            getProductsDefaultParams: getProductsJsonParams.copyWith(
              searchValue: balanceEan,
            ),
          );

          expect(response, Exception());
        } catch (e) {
          // ignore
        }

        verify(
          () => soapProductsDatasource.get(
            baseUrl: baseUrl,
            isCompetingPrices: true,
            parametersPayload: {
              "CrossIdentity": crossIdentity,
              "EnterpriseCodes": getProductsJsonParams.EnterpriseCodes,
              "SearchValue": balanceEan,
              "SearchType": getProductsJsonParams.searchType.code,
              "RoutineInt": getProductsJsonParams.routine.code,
              "LastBuyEntranceQuantity":
                  getProductsJsonParams.LastBuyEntranceQuantity ?? 5,
              "RequestTypeCode":
                  getProductsJsonParams.buyRequestParams!.requestTypeCode,
              "SupplierCode":
                  getProductsJsonParams.buyRequestParams!.supplierCode,
              "SearchTypeInt": getProductsJsonParams.searchType.code,
              "ResearchOfPriceFilters": {
                "ResearchOfPriceCode": getProductsJsonParams
                    .competingPricesParams!
                    .ResearchOfPriceCode,
                "ConcurrentCode":
                    getProductsJsonParams.competingPricesParams!.ConcurrentCode,
                "OnlyAssociated":
                    getProductsJsonParams.competingPricesParams!.OnlyAssociated,
                "InformedPrices": getProductsJsonParams
                    .competingPricesParams!
                    .searchType
                    .code,
              },
            },
          ),
        ).called(1);
        verify(
          () => soapProductsDatasource.get(
            baseUrl: baseUrl,
            isCompetingPrices: true,
            parametersPayload: {
              "CrossIdentity": crossIdentity,
              "EnterpriseCodes": getProductsJsonParams.EnterpriseCodes,
              "SearchValue": balanceEan
                  .replaceFirst(RegExp(r'2'), '')
                  .replaceRange(
                    enterpriseEntity.ProductCodeSizeOfBalanceLabel!,
                    null,
                    enterpriseEntity.ProductCodeWithCheckerDigit == true
                        ? ""
                        : ".",
                  ),
              "SearchType": getProductsJsonParams.searchType.code,
              "RoutineInt": getProductsJsonParams.routine.code,
              "LastBuyEntranceQuantity":
                  getProductsJsonParams.LastBuyEntranceQuantity ?? 5,
              "RequestTypeCode":
                  getProductsJsonParams.buyRequestParams!.requestTypeCode,
              "SupplierCode":
                  getProductsJsonParams.buyRequestParams!.supplierCode,
              "SearchTypeInt": getProductsJsonParams.searchType.code,
              "ResearchOfPriceFilters": {
                "ResearchOfPriceCode": getProductsJsonParams
                    .competingPricesParams!
                    .ResearchOfPriceCode,
                "ConcurrentCode":
                    getProductsJsonParams.competingPricesParams!.ConcurrentCode,
                "OnlyAssociated":
                    getProductsJsonParams.competingPricesParams!.OnlyAssociated,
                "InformedPrices": getProductsJsonParams
                    .competingPricesParams!
                    .searchType
                    .code,
              },
            },
          ),
        ).called(1);
      },
    );
  });
  group("Products inventory datasource", () {
    test("Should behave correctly when pass all params", () async {
      final response = await sut.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        enterpriseEntity: enterpriseEntity,
        getProductsDefaultParams: getProductsInventoryParams,
      );

      expect(
        response,
        inventoryProductsEntities
            .map((e) => InventoryProductModel.fromEntity(e).toEntity())
            .toList(),
      );

      verify(
        () => soapInventoryDatasource.get(
          baseUrl: baseUrl,
          parametersPayload: {
            "crossIdentity": crossIdentity,
            "enterpriseCode": enterpriseEntity.Code,
            "searchValue": getProductsInventoryParams.searchValue,
            "searchTypeInt": getProductsInventoryParams.searchType.code,
            "inventoryProcessCode":
                getProductsInventoryParams.inventoryProcessCode,
            "inventoryCountingCode":
                getProductsInventoryParams.inventoryCountingCode,
          },
        ),
      ).called(1);
    });

    test(
      "Should search again when is balance code and fails the first time",
      () async {
        soapInventoryDatasource.mockError();

        const balanceEan = '2000000000000';

        try {
          final response = await sut.load(
            baseUrl: baseUrl,
            crossIdentity: crossIdentity,
            enterpriseEntity: enterpriseEntity,
            getProductsDefaultParams: getProductsInventoryParams.copyWith(
              searchValue: balanceEan,
            ),
          );

          expect(response, Exception());
        } catch (e) {
          // ignore
        }

        verify(
          () => soapInventoryDatasource.get(
            baseUrl: baseUrl,
            parametersPayload: {
              "crossIdentity": crossIdentity,
              "enterpriseCode": enterpriseEntity.Code,
              "searchValue": balanceEan,
              "searchTypeInt": getProductsInventoryParams.searchType.code,
              "inventoryProcessCode":
                  getProductsInventoryParams.inventoryProcessCode,
              "inventoryCountingCode":
                  getProductsInventoryParams.inventoryCountingCode,
            },
          ),
        ).called(1);
        verify(
          () => soapInventoryDatasource.get(
            baseUrl: baseUrl,
            parametersPayload: {
              "crossIdentity": crossIdentity,
              "enterpriseCode": enterpriseEntity.Code,
              "searchValue": balanceEan
                  .replaceFirst(RegExp(r'2'), '')
                  .replaceRange(
                    enterpriseEntity.ProductCodeSizeOfBalanceLabel!,
                    null,
                    enterpriseEntity.ProductCodeWithCheckerDigit == true
                        ? ""
                        : ".",
                  ),
              "searchTypeInt": getProductsInventoryParams.searchType.code,
              "inventoryProcessCode":
                  getProductsInventoryParams.inventoryProcessCode,
              "inventoryCountingCode":
                  getProductsInventoryParams.inventoryCountingCode,
            },
          ),
        ).called(1);
      },
    );
  });
}
