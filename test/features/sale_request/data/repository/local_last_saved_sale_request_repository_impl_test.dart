import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/data/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class LocalLastSavedSaleRequestDatasourceSpy extends Mock
    implements ILocalLastSavedSaleRequestDatasource {
  LocalLastSavedSaleRequestDatasourceSpy() {
    when(
      () => this.save(
        value: any(named: 'value'),
        enterpriseCode: any(named: 'enterpriseCode'),
      ),
    ).thenAnswer((_) async {});
  }

  void mockLoad(SoapLastSavedSaleRequestModel? response) =>
      when(() => this.load(any())).thenAnswer((_) async => response);
}

void main() {
  late ILocalLastSavedSaleRequestRepository sut;
  late LocalLastSavedSaleRequestDatasourceSpy mockDatasource;

  late LastSavedSaleRequestEntity lastSavedSaleRequestEntity;
  late int enterpriseCode;

  setUp(() {
    mockDatasource = LocalLastSavedSaleRequestDatasourceSpy();
    sut = LocalLastSavedSaleRequestRepositoryImpl(mockDatasource);

    lastSavedSaleRequestEntity = LastSavedSaleRequestEntity(
      saleRequestEntity: EntityFactory.makeSaleRequestEntity(),
      saleRequestNumber: faker.randomGenerator.integer(100).toString(),
    );
    enterpriseCode = faker.randomGenerator.integer(100);

    mockDatasource.mockLoad(
      SoapLastSavedSaleRequestModel.fromEntity(lastSavedSaleRequestEntity),
    );
  });

  setUpAll(() {
    registerFallbackValue(
      SoapLastSavedSaleRequestModel.fromEntity(
        LastSavedSaleRequestEntity(
          saleRequestEntity: EntityFactory.makeSaleRequestEntity(),
          saleRequestNumber: faker.randomGenerator.integer(100).toString(),
        ),
      ),
    );
  });

  test('should behave correctly on save', () async {
    await sut.save(
      value: lastSavedSaleRequestEntity,
      enterpriseCode: enterpriseCode,
    );

    verify(
      () => mockDatasource.save(
        value: SoapLastSavedSaleRequestModel.fromEntity(
          lastSavedSaleRequestEntity,
        ),
        enterpriseCode: enterpriseCode,
      ),
    ).called(1);
  });

  test('should behave correctly on load', () async {
    final response = await sut.load(enterpriseCode);

    expect(
      response,
      SoapLastSavedSaleRequestModel.fromEntity(
        lastSavedSaleRequestEntity,
      ).toEntity(),
    );

    verify(() => mockDatasource.load(enterpriseCode)).called(1);
  });
}
