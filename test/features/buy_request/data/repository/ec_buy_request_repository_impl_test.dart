import 'package:celta_inventario/core/domain/entities/entities.dart';
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
  late LoadShallowBuyRequestParams params;
  late List<EcBuyRequestDtoEntity> entities;
  late List<EcBuyRequestDtoModel> models;

  setUpAll(() {
    registerFallbackValue(
      LoadShallowBuyRequestParams(
        requestParams: const EcRequestParams(
          workingUrl: '',
          user: '',
          accessKey: '',
        ),
        selectedDate: DateTime(2026),
        enterpriseCode: 0,
      ),
    );
  });

  setUp(() {
    datasource = EcBuyRequestDatasourceSpy();
    sut = EcBuyRequestRepositoryImpl(datasource);

    params = LoadShallowBuyRequestParams(
      requestParams: EcRequestParams(
        workingUrl: faker.internet.httpUrl(),
        user: faker.guid.guid(),
        accessKey: faker.guid.guid(),
      ),
      selectedDate: DateTime(2026, 7, 20),
      enterpriseCode: faker.randomGenerator.integer(100),
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

        final response = await sut.loadShallow(params);

        expect(response, entities);
        verify(() => datasource.loadShallow(params)).called(1);
      },
    );
  });
}
