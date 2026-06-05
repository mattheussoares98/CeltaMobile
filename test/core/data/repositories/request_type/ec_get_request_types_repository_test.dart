// test/core/data/repositories/request_type/ec_get_request_types_repository_test.dart
import 'package:celta_inventario/core/data/datasource/request_type/request_type.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/data/repositories/request_type/request_type.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/request_type/request_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcGetRequestTypesDatasourceSpy extends Mock
    implements IEcGetRequestTypesDatasource {
  void mockSearch(List<BSFRequestTypeModel> response) {
    when(
      () => this.search(
        parameters: any(named: 'parameters'),
        params: any(named: 'params'),
      ),
    ).thenAnswer((_) async => response);
  }
}

void main() {
  late IEcGetRequestTypesRepository sut;
  late EcGetRequestTypesDatasourceSpy datasource;

  late EcRequestTypeParametersEntity parameters;
  late EcRequestParams params;

  void initSut() {
    sut = EcGetRequestTypesRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = EcGetRequestTypesDatasourceSpy();
  }

  void initEntities() {
    parameters = EntityFactory.makeEcRequestTypeParametersEntity();
    params = EntityFactory.makeEcRequestParams();
  }

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcRequestTypeParametersEntity());
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  setUp(() {
    initEntities();
    initInjections();
    initSut();
  });

  group('search', () {
    test('should call datasource and filter to return only request types allowed on mobile apps', () async {
      final mockModels = [
        const BSFRequestTypeModel(
          code: 1,
          name: 'Request Type 1',
          allowSelectRequestTypeToAppRequests: true,
        ),
        const BSFRequestTypeModel(
          code: 2,
          name: 'Request Type 2',
          allowSelectRequestTypeToAppRequests: false,
        ),
        const BSFRequestTypeModel(
          code: 3,
          name: 'Request Type 3',
          allowSelectRequestTypeToAppRequests: null,
        ),
      ];
      datasource.mockSearch(mockModels);

      final result = await sut.search(parameters: parameters, params: params);

      expect(result, [mockModels[0].toEntity()]);
      verify(
        () => datasource.search(parameters: parameters, params: params),
      ).called(1);
    });
  });
}
