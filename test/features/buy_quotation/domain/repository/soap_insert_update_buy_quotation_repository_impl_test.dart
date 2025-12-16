import 'package:celta_intelligence/features/buy_quotation/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/buy_quotation/data/models/buy_quotation_model.dart';
import 'package:celta_intelligence/features/buy_quotation/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapInsertUpdateBuyQuotationDatasourceSpy extends Mock
    implements ISoapInsertUpdateBuyQuotationDatasource {
  SoapInsertUpdateBuyQuotationDatasourceSpy() {
    when(
      () => this.insertUpdate(
        baseUrl: any(named: 'baseUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        buyQuotation: any(named: 'buyQuotation'),
      ),
    ).thenAnswer((_) async {});
  }
}

void main() {
  late ISoapInsertUpdateBuyQuotationRepository sut;

  late SoapInsertUpdateBuyQuotationDatasourceSpy datasource;
  late BuyQuotationModel buyQuotationModel;
  late String baseUrl;
  late String crossIdentity;

  void initSut() {
    sut = SoapInsertUpdateBuyQuotationRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapInsertUpdateBuyQuotationDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    buyQuotationModel = BuyQuotationModel.fromEntity(
      EntityFactory.makeBuyQuotationEntity(),
    );
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(
      BuyQuotationModel.fromEntity(EntityFactory.makeBuyQuotationEntity()),
    );
  });

  test('should behave correctly on success', () async {
    await sut.insertUpdate(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      buyQuotation: buyQuotationModel.toEntity(),
    );

    verify(
      () => datasource.insertUpdate(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        buyQuotation: buyQuotationModel,
      ),
    ).called(1);
  });
  test(
    'should send 0 code in products and enterprises when codes are null',
    () async {
      await sut.insertUpdate(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        buyQuotation: buyQuotationModel.toEntity().copyWith(
          Enterprises: buyQuotationModel.Enterprises?.map(
            (e) => e.toEntity().annulValues(annulCode: true),
          ).toList(),
          Products: buyQuotationModel.Products?.map(
            (e) => e.toEntity().annulValues(annulCode: true),
          ).toList(),
        ),
      );

      verify(
        () => datasource.insertUpdate(
          baseUrl: baseUrl,
          crossIdentity: crossIdentity,
          buyQuotation: BuyQuotationModel.fromEntity(
            buyQuotationModel.toEntity().copyWith(
              Enterprises: buyQuotationModel.Enterprises?.map(
                (e) => e.toEntity().copyWith(Code: 0),
              ).toList(),
              Products: buyQuotationModel.Products?.map(
                (e) => e.toEntity().copyWith(Code: 0),
              ).toList(),
            ),
          ),
        ),
      ).called(1);
    },
  );
}
