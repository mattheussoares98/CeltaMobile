import 'package:celta_inventario/features/buy_movement/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_movement/data/models/models.dart';
import 'package:celta_inventario/features/buy_movement/data/repositories/repositories.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_movement/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcBuyMovementDatasourceSpy extends Mock
    implements IEcBuyMovementDatasource {}

void main() {
  late IEcBuyMovementRepository sut;
  late EcBuyMovementDatasourceSpy datasource;
  late LoadShallowBuyMovementParams shallowParams;
  late LoadBuyMovementDetailsParams detailsParams;
  late List<EcBuyMovementDtoEntity> entities;
  late List<EcBuyMovementDtoModel> models;

  setUpAll(() {
    registerFallbackValue(
      LoadShallowBuyMovementParams(
        requestParams: EntityFactory.makeEcRequestParams(),
        selectedDate: faker.date.dateTime(),
        enterpriseCode: faker.randomGenerator.integer(100),
      ),
    );
    registerFallbackValue(
      LoadBuyMovementDetailsParams(
        requestParams: EntityFactory.makeEcRequestParams(),
        buyMovementCode: faker.randomGenerator.integer(100),
      ),
    );
  });

  setUp(() {
    datasource = EcBuyMovementDatasourceSpy();
    sut = EcBuyMovementRepositoryImpl(datasource);

    shallowParams = LoadShallowBuyMovementParams(
      requestParams: EntityFactory.makeEcRequestParams(),
      selectedDate: faker.date.dateTime(),
      enterpriseCode: faker.randomGenerator.integer(100),
    );
    detailsParams = LoadBuyMovementDetailsParams(
      requestParams: EntityFactory.makeEcRequestParams(),
      buyMovementCode: faker.randomGenerator.integer(100),
    );

    entities = List.generate(
      faker.randomGenerator.integer(3, min: 1),
      (_) => EntityFactory.makeEcBuyMovementDtoEntity(),
    );
    models = entities.map(EcBuyMovementDtoModel.fromEntity).toList();
  });

  group('loadShallow', () {
    test(
      'should call datasource with correct parameters and return entities',
      () async {
        when(
          () => datasource.loadShallow(any()),
        ).thenAnswer((_) async => models);

        final response = await sut.loadShallow(shallowParams);

        expect(response, entities);
        verify(() => datasource.loadShallow(shallowParams)).called(1);
      },
    );
  });

  group('loadDetails', () {
    test(
      'should call datasource with correct parameters and return entity',
      () async {
        when(
          () => datasource.loadDetails(any()),
        ).thenAnswer((_) async => models.first);

        final response = await sut.loadDetails(detailsParams);

        expect(response, entities.first);
        verify(() => datasource.loadDetails(detailsParams)).called(1);
      },
    );
  });
}
