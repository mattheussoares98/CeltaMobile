import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/data/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/entity_factory.dart';

class MockEcSellerDatasource extends Mock implements IEcSellerDatasource {}

void main() {
  late IEcSellerRepository repository;
  late MockEcSellerDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockEcSellerDatasource();
    repository = EcSellerRepositoryImpl(mockDatasource);
  });

  group('get', () {
    final tEntity = EntityFactory.makeSellerEntity();
    final tModel = EcSellerModel.fromEntity(tEntity);
    final tModelList = [tModel];
    final tEntityList = [tEntity];
    final tEnterpriseCode = faker.randomGenerator.integer(100);
    final tParams = EcGetSellerParams(
      params: EntityFactory.makeEcRequestParams(),
      enterpriseCode: tEnterpriseCode,
    );

    test(
      'should return List<SellerEntity> when datasource returns data successfully',
      () async {
        // Arrange
        when(
          () => mockDatasource.get(tParams),
        ).thenAnswer((_) async => tModelList);

        // Act
        final result = await repository.get(tParams);

        // Assert
        expect(result, equals(tEntityList));
        verify(() => mockDatasource.get(tParams)).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test('should throw an exception when datasource fails', () async {
      // Arrange
      final exception = Exception('Failed to get sellers');
      when(() => mockDatasource.get(tParams)).thenThrow(exception);

      // Act
      final call = repository.get(tParams);

      // Assert
      expect(() => call, throwsA(equals(exception)));
      verify(() => mockDatasource.get(tParams)).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });
  });
}
