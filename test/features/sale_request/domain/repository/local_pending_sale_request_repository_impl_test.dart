import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class LocalPendingSaleRequestDatasourceSpy extends Mock
    implements ILocalPendingSaleRequestDatasource {
  LocalPendingSaleRequestDatasourceSpy() {
    when(() => this.save(any(), any())).thenAnswer((_) async {});
    when(() => this.clear(any())).thenAnswer((_) async {});
  }

  void mockLoad(SoapPendingSaleRequestModel? response) =>
      when(() => this.load(any())).thenAnswer((_) async => response);
}

void main() {
  late ILocalPendingSaleRequestRepository sut;
  late LocalPendingSaleRequestDatasourceSpy mockDatasource;

  late SaleRequestEntity pendingSaleRequestEntity;
  late int enterpriseCode;

  setUp(() {
    mockDatasource = LocalPendingSaleRequestDatasourceSpy();
    sut = LocalPendingSaleRequestRepositoryImpl(mockDatasource);

    pendingSaleRequestEntity = EntityFactory.makePendingSaleRequestEntity();
    enterpriseCode = faker.randomGenerator.integer(100);

    mockDatasource.mockLoad(
      SoapPendingSaleRequestModel.fromEntity(pendingSaleRequestEntity),
    );
  });

  setUpAll(() {
    registerFallbackValue(
      SoapPendingSaleRequestModel.fromEntity(
        EntityFactory.makePendingSaleRequestEntity(),
      ),
    );
  });

  test('should behave correctly on save', () async {
    await sut.save(pendingSaleRequestEntity, enterpriseCode);

    verify(
      () => mockDatasource.save(
        SoapPendingSaleRequestModel.fromEntity(pendingSaleRequestEntity),
        enterpriseCode,
      ),
    ).called(1);
  });

  test('should behave correctly on load', () async {
    final response = await sut.load(enterpriseCode);

    expect(response, pendingSaleRequestEntity);

    verify(() => mockDatasource.load(enterpriseCode)).called(1);
  });
  test('should behave correctly on clear', () async {
    await sut.clear(enterpriseCode);

    verify(() => mockDatasource.clear(enterpriseCode)).called(1);
  });
}
