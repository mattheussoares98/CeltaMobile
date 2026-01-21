import 'package:celta_inventario/features/buy_quotation/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_quotation/data/models/buy_quotation_model.dart';
import 'package:celta_inventario/features/buy_quotation/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapInsertUpdateBuyQuotationDatasourceSpy extends Mock
    implements ISoapInsertUpdateBuyQuotationDatasource {
  SoapInsertUpdateBuyQuotationDatasourceSpy() {
    when(
      () => this.insertUpdate(
        workingUrl: any(named: 'workingUrl'),
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
  late String workingUrl;
  late String crossIdentity;
  late DateTime now;
  late String observations;

  void initSut() {
    sut = SoapInsertUpdateBuyQuotationRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapInsertUpdateBuyQuotationDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    now = DateTime.now();
    buyQuotationModel = BuyQuotationModel.fromEntity(
      EntityFactory.makeBuyQuotationEntity(dateOfCreation: now),
    );
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    observations = faker.lorem.sentence();
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
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      now: now,
      buyQuotation: buyQuotationModel.toEntity(),
      observations: observations,
    );

    verify(
      () => datasource.insertUpdate(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        buyQuotation: BuyQuotationModel.fromEntity(
          buyQuotationModel.toEntity().copyWith(Observations: observations),
        ),
      ),
    ).called(1);
  });
  test(
    'should behave correctly when is inserting a new buy quotation',
    () async {
      await sut.insertUpdate(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        now: now,
        observations: observations,
        buyQuotation: buyQuotationModel
            .toEntity()
            .copyWith(
              Enterprises: buyQuotationModel.Enterprises?.map(
                (e) => e.toEntity().annulValues(annulCode: true),
              ).toList(),
              Products: buyQuotationModel.Products?.map(
                (e) => e.toEntity().annulValues(annulCode: true),
              ).toList(),
            )
            .annulValues(annulCode: true, annulDateOfCreation: true),
      );

      final entity = buyQuotationModel.toEntity();
      verify(
        () => datasource.insertUpdate(
          workingUrl: workingUrl,
          crossIdentity: crossIdentity,
          buyQuotation: BuyQuotationModel.fromEntity(
            entity.copyWith(
              Enterprises: entity.Enterprises?.map(
                (e) => e.copyWith(Code: 0),
              ).toList().where((x) => x.isSelected == true).toList(),
              Products: entity.Products?.map(
                (e) => e.copyWith(Code: 0),
              ).toList(),
              Code: 0,
              DateOfCreation: now,
              Observations: observations,
            ),
          ),
        ),
      ).called(1);
    },
  );
}
