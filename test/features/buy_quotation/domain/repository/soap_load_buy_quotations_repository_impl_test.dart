import 'package:celta_intelligence/features/buy_quotation/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/buy_quotation/data/models/buy_quotation_model.dart';
import 'package:celta_intelligence/features/buy_quotation/domain/entities/entities.dart';
import 'package:celta_intelligence/features/buy_quotation/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapLoadBuyQuotationsDatasourceSpy extends Mock
    implements ISoapLoadBuyQuotationsDatasource {
  void mockLoad(List<BuyQuotationModel> buyQuotations) {
    when(
      () => this.load(
        baseUrl: any(named: 'baseUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        enterpriseCode: any(named: 'enterpriseCode'),
        isCompleteSearch: any(named: 'isCompleteSearch'),
        searchValue: any(named: 'searchValue'),
        dataType: any(named: 'dataType'),
        inclusiveExpired: any(named: 'inclusiveExpired'),
      ),
    ).thenAnswer((_) async => buyQuotations);
  }
}

void main() {
  late ISoapLoadBuyQuotationsRepository sut;

  late SoapLoadBuyQuotationsDatasourceSpy datasource;
  late List<BuyQuotationModel> buyQuotationsModels;
  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late String? codeForFullSearch;

  void initSut() {
    sut = SoapLoadBuyQuotationsRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapLoadBuyQuotationsDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(buyQuotationsModels);
  }

  void initEntities() {
    buyQuotationsModels = [
      EntityFactory.makeBuyQuotationEntity(),
      EntityFactory.makeBuyQuotationEntity(),
      EntityFactory.makeBuyQuotationEntity(),
    ].map((e) => BuyQuotationModel.fromEntity(e)).toList();
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    codeForFullSearch = faker.randomGenerator.boolean()
        ? faker.randomGenerator.integer(100).toString()
        : null;
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in SearchBuyQuotationDataType.values) {
      registerFallbackValue(value);
    }
  });

  test('should behave correctly on success', () async {
    final result = await sut.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      codeForFullSearch: codeForFullSearch,
    );

    expect(result, buyQuotationsModels.map((e) => e.toEntity()).toList());

    verify(
      () => datasource.load(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        isCompleteSearch: codeForFullSearch != null,
        searchValue: codeForFullSearch ?? '%',
        dataType: SearchBuyQuotationDataType.byPersonalizedCode,
        inclusiveExpired: false,
      ),
    ).called(1);

    verifyNoMoreInteractions(datasource);
  });
}
