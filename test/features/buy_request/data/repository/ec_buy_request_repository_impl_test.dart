import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/data/models/ec_buy_request_dto/ec_buy_request_dto_model.dart';
import 'package:celta_inventario/features/buy_request/data/repository/repository.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcBuyRequestDatasourceSpy extends Mock
    implements IEcBuyRequestDatasource {}

void main() {
  late IEcBuyRequestRepository sut;
  late EcBuyRequestDatasourceSpy datasource;
  late LoadShallowBuyRequestParams shallowParams;
  late LoadBuyRequestDetailsParams detailsParams;
  late List<EcBuyRequestDtoEntity> entities;
  late List<EcBuyRequestDtoModel> models;

  setUpAll(() {
    registerFallbackValue(
      LoadShallowBuyRequestParams(
        requestParams: EntityFactory.makeEcRequestParams(),
        selectedDate: DateTime(2026),
        finalDate: DateTime(2026, 3, 31),
        enterpriseCode: 0,
      ),
    );

    registerFallbackValue(
      LoadBuyRequestDetailsParams(
        requestParams: EntityFactory.makeEcRequestParams(),
        buyRequestCode: 0,
      ),
    );
  });

  setUp(() {
    datasource = EcBuyRequestDatasourceSpy();
    sut = EcBuyRequestRepositoryImpl(datasource);

    shallowParams = LoadShallowBuyRequestParams(
      requestParams: EntityFactory.makeEcRequestParams(),
      selectedDate: DateTime(2026, 7, 20),
      finalDate: DateTime(2026, 10, 18),
      enterpriseCode: faker.randomGenerator.integer(100),
    );
    detailsParams = LoadBuyRequestDetailsParams(
      requestParams: EntityFactory.makeEcRequestParams(),
      buyRequestCode: faker.randomGenerator.integer(100),
    );

    entities = [
      EntityFactory.makeEcBuyRequestDtoEntity(),
      EntityFactory.makeEcBuyRequestDtoEntity(),
      EntityFactory.makeEcBuyRequestDtoEntity(),
    ];

    models = entities.map((e) => EcBuyRequestDtoModel.fromEntity(e)).toList();
  });

  group('loadShallow', () {
    test(
      'should call datasource with correct parameters and return list of EcBuyRequestDtoEntity on success',
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
      'should call datasource with correct parameters and return EcBuyRequestDtoEntity on success',
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
