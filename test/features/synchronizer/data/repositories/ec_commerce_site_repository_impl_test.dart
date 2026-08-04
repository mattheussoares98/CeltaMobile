import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/data/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcCommerceSiteDatasource extends Mock
    implements IEcCommerceSiteDatasource {}

void main() {
  late IEcCommerceSiteRepository sut;
  late MockEcCommerceSiteDatasource datasource;
  late EcRequestParams params;

  setUp(() {
    datasource = MockEcCommerceSiteDatasource();
    sut = EcCommerceSiteRepositoryImpl(datasource);
    params = EntityFactory.makeEcRequestParams();
  });

  test('should map commerce site models to entities', () async {
    final entity = EntityFactory.makeEcCommerceSiteEntity();
    final models = [EcCommerceSiteModel.fromEntity(entity)];
    when(
      () => datasource.getCommerceSites(params, entity.enterpriseCode),
    ).thenAnswer((_) async => models);

    final result = await sut.getCommerceSites(params, entity.enterpriseCode);

    expect(result, [entity]);
    verify(
      () => datasource.getCommerceSites(params, entity.enterpriseCode),
    ).called(1);
    verifyNoMoreInteractions(datasource);
  });

  test('should propagate datasource errors', () async {
    final enterpriseCode =
        EntityFactory.makeEcCommerceSiteEntity().enterpriseCode;
    final exception = Exception('Failed to get commerce sites');
    when(
      () => datasource.getCommerceSites(params, enterpriseCode),
    ).thenThrow(exception);

    final call = sut.getCommerceSites(params, enterpriseCode);

    await expectLater(call, throwsA(same(exception)));
    verify(() => datasource.getCommerceSites(params, enterpriseCode)).called(1);
    verifyNoMoreInteractions(datasource);
  });
}
