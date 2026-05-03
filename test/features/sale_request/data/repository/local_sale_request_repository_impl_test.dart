import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/data/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class LocalSaleRequestDatasourceSpy extends Mock
    implements ILocalSaleRequestDatasource {
  LocalSaleRequestDatasourceSpy() {
    when(() => this.save(any(), any())).thenAnswer((_) async {});
    when(() => this.clear(any())).thenAnswer((_) async {});
  }

  void mockLoad(SoapSaleRequestModel? response) =>
      when(() => this.load(any())).thenAnswer((_) async => response);
}

void main() {
  late ILocalSaleRequestRepository sut;
  late LocalSaleRequestDatasourceSpy mockDatasource;

  late SaleRequestEntity saleRequestEntity;
  late int enterpriseCode;

  setUp(() {
    mockDatasource = LocalSaleRequestDatasourceSpy();
    sut = LocalSaleRequestRepositoryImpl(mockDatasource);

    saleRequestEntity = EntityFactory.makeSaleRequestEntity();
    enterpriseCode = faker.randomGenerator.integer(100);

    mockDatasource.mockLoad(SoapSaleRequestModel.fromEntity(saleRequestEntity));
  });

  setUpAll(() {
    registerFallbackValue(
      SoapSaleRequestModel.fromEntity(EntityFactory.makeSaleRequestEntity()),
    );
  });

  test('should behave correctly on save', () async {
    await sut.save(saleRequestEntity, enterpriseCode);

    verify(
      () => mockDatasource.save(
        SoapSaleRequestModel.fromEntity(saleRequestEntity),
        enterpriseCode,
      ),
    ).called(1);
  });

  test('should behave correctly on load', () async {
    final response = await sut.load(enterpriseCode);

    expect(
      response,
      SoapSaleRequestModel.fromEntity(saleRequestEntity).toEntity(),
    );

    verify(() => mockDatasource.load(enterpriseCode)).called(1);
  });
  test('should behave correctly on clear', () async {
    await sut.clear(enterpriseCode);

    verify(() => mockDatasource.clear(enterpriseCode)).called(1);
  });
}
