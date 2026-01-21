import 'package:celta_inventario/features/transfer_between_stocks/data/datasource/datasource.dart';
import 'package:celta_inventario/features/transfer_between_stocks/data/models/models.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class LocalItemsLotDatasourceSpy extends Mock
    implements ILocalItemsLotDatasource {
  LocalItemsLotDatasourceSpy() {
    when(() => this.addItem(any())).thenAnswer((_) async => {});
    when(() => this.removeItem(any())).thenAnswer((_) async => {});
    when(() => this.clear(any())).thenAnswer((_) async {});
  }

  void mockLoad(List<ProductLotInfoModel> response) {
    when(() => this.load(any())).thenAnswer((_) async => response);
  }
}

void main() {
  late LocalItemsLotRepositoryImpl sut;
  late LocalItemsLotDatasourceSpy mockDatasource;
  late List<ProductLotInfoEntity> itemsEntities;
  late int enterpriseCode;

  setUp(() {
    mockDatasource = LocalItemsLotDatasourceSpy();
    sut = LocalItemsLotRepositoryImpl(mockDatasource);

    itemsEntities = [
      EntityFactory.makeProductLotInfoEntity(),
      EntityFactory.makeProductLotInfoEntity(),
      EntityFactory.makeProductLotInfoEntity(),
    ];

    mockDatasource.mockLoad(
      itemsEntities.map((e) => ProductLotInfoModel.fromEntity(e)).toList(),
    );

    enterpriseCode = faker.randomGenerator.integer(100);
  });

  setUpAll(() {
    registerFallbackValue(
      ProductLotInfoModel.fromEntity(EntityFactory.makeProductLotInfoEntity()),
    );
  });

  group('addItem', () {
    test(
      'should call datasource.addItem with the correctly mapped model',
      () async {
        await sut.addItem(itemsEntities.first);

        verify(
          () => mockDatasource.addItem(
            ProductLotInfoModel.fromEntity(itemsEntities.first),
          ),
        );
      },
    );
  });

  group('removeItem', () {
    test(
      'should call datasource.removeItem with the correctly mapped model',
      () async {
        await sut.removeItem(itemsEntities.first);

        verify(
          () => mockDatasource.removeItem(
            ProductLotInfoModel.fromEntity(itemsEntities.first),
          ),
        );
      },
    );
  });

  group('load', () {
    test('should return a list of entities when datasource succeeds', () async {
      final result = await sut.load(enterpriseCode);

      expect(result, itemsEntities);
    });
  });

  group('clear', () {
    test('should call datasource.clear', () async {
      await sut.clear(enterpriseCode);

      verify(() => mockDatasource.clear(enterpriseCode)).called(1);
    });
  });
}
