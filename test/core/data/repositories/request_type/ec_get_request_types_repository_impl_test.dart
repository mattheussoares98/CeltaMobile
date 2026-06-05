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
  late List<BSFRequestTypeModel> requestTypes;

  void initSut() {
    sut = EcGetRequestTypesRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = EcGetRequestTypesDatasourceSpy();
  }

  void initEntities() {
    parameters = EntityFactory.makeEcRequestTypeParametersEntity();
    params = EntityFactory.makeEcRequestParams();
    requestTypes = [
      BSFRequestTypeModel.fromEntity(EntityFactory.makeBSFRequestTypeEntity()),
      BSFRequestTypeModel.fromEntity(EntityFactory.makeBSFRequestTypeEntity()),
      BSFRequestTypeModel.fromEntity(EntityFactory.makeBSFRequestTypeEntity()),
    ];
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
    test('should call datasource with correct params', () async {
      datasource.mockSearch(requestTypes);

      final result = await sut.search(parameters: parameters, params: params);

      expect(result, requestTypes.map((e) => e.toEntity()).toList());
      verify(
        () => datasource.search(parameters: parameters, params: params),
      ).called(1);
    });
  });
}
