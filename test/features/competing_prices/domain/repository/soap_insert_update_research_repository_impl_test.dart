import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:celta_inventario/features/competing_prices/data/datasource/datasource.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapInsertUpdateResearchDatasourceSpy extends Mock
    implements ISoapInsertUpdateResearchDatasource {
  SoapInsertUpdateResearchDatasourceSpy() {
    when(
      () => this.insertUpdate(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        enterpriseCode: any(named: 'enterpriseCode'),
        name: any(named: 'name'),
        observations: any(named: 'observations'),
        researchCode: any(named: 'researchCode'),
        associateConcurrentParams: any(named: 'associateConcurrentParams'),
      ),
    ).thenAnswer((_) async {});
  }
}

void main() {
  late ISoapInsertUpdateResearchRepository sut;

  late SoapInsertUpdateResearchDatasourceSpy datasource;

  late String workingUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late String name;
  late int researchCode;
  late String? observations;
  late ConcurrentEntity concurrentToAssociate;

  void initSut() {
    sut = SoapInsertUpdateResearchRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapInsertUpdateResearchDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    name = faker.lorem.word();
    researchCode = faker.randomGenerator.integer(100);
    observations = faker.lorem.word();
    crossIdentity = faker.guid.guid();
    workingUrl = faker.internet.httpUrl();
    enterpriseCode = faker.randomGenerator.integer(1000);
    concurrentToAssociate = EntityFactory.makeConcurrentEntity();
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

  test('should call with correct values when pass all params', () async {
    await sut.insertUpdate(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      name: name,
      observations: observations,
      researchCode: researchCode,
      concurrentToAssociate: concurrentToAssociate,
    );

    verify(
      () => datasource.insertUpdate(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        name: name,
        observations: observations,
        researchCode: researchCode,
        associateConcurrentParams: {
          "IsAssociatingConcurrents": true,
          "Concurrents": [
            {
              "ResearchOfPriceCode": researchCode,
              "ConcurrentCode": concurrentToAssociate.ConcurrentCode,
              "Observation": concurrentToAssociate.Observation,
            },
          ],
        },
      ),
    ).called(1);

    verifyNoMoreInteractions(datasource);
  });
  test(
    'should call with correct values when DOESNT pass researchCode params',
    () async {
      await sut.insertUpdate(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        name: name,
      );

      verify(
        () => datasource.insertUpdate(
          workingUrl: workingUrl,
          crossIdentity: crossIdentity,
          enterpriseCode: enterpriseCode,
          name: name,
          researchCode: 0,
          associateConcurrentParams: {},
        ),
      ).called(1);

      verifyNoMoreInteractions(datasource);
    },
  );
}
