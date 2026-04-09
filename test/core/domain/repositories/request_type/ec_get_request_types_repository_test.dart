import 'package:celta_inventario/core/data/datasource/request_type/request_type.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/request_type/request_type.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcGetRequestTypesDatasourceSpy extends Mock
    implements IEcGetRequestTypesDatasource {
  void mockSearch(List<BSFRequestTypeModel> response) {
    when(
      () => this.search(
        parameters: any(named: 'parameters'),
        enterpriseCode: any(named: 'enterpriseCode'),
        params: any(named: 'params'),
      ),
    ).thenAnswer((_) async => response);
  }
}

void main() {
  late IEcGetRequestTypesRepository sut;
  late EcGetRequestTypesDatasourceSpy datasource;

  late int enterpriseCode;
  late BSFSearchRequestTypeParametersEntity parameters;
  late EcRequestParams params;

  void initSut() {
    sut = EcGetRequestTypesRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = EcGetRequestTypesDatasourceSpy();
  }

  void initEntities() {
    enterpriseCode = faker.randomGenerator.integer(100);
    parameters = EntityFactory.makeBSFSearchRequestTypeParametersEntity();
    params = EntityFactory.makeEcRequestParams();
  }

  setUpAll(() {
    registerFallbackValue(
      EntityFactory.makeBSFSearchRequestTypeParametersEntity(),
    );
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  setUp(() {
    initEntities();
    initInjections();
    initSut();
  });

  group('search', () {
    test('should call datasource with correct params', () async {
      final mockModels = [
        const BSFRequestTypeModel(code: 1, name: 'Request Type 1'),
      ];
      datasource.mockSearch(mockModels);

      final result = await sut.search(
        parameters: parameters,
        enterpriseCode: enterpriseCode,
        params: params,
      );

      expect(result, mockModels.map((e) => e.toEntity()).toList());
      verify(
        () => datasource.search(
          parameters: parameters,
          enterpriseCode: enterpriseCode,
          params: params,
        ),
      ).called(1);
    });
  });
}
