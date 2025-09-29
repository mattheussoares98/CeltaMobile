import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/domain/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class LocalItemsLotDatasourceSpy extends Mock
    implements ILocalItemsLotDatasource {
  LocalItemsLotDatasourceSpy() {
    when(() => this.addItem(any())).thenAnswer((_) async => {});
    when(() => this.removeItem(any())).thenAnswer((_) async => {});
    when(() => this.clear()).thenAnswer((_) async {});
  }

  void mockLoad(List<AdjustStockItemModel> response) {
    when(() => this.load()).thenAnswer((_) async => response);
  }
}

void main() {
  late LocalItemsLotRepositoryImpl sut;
  late LocalItemsLotDatasourceSpy mockDatasource;
  late List<AdjustStockItemEntity> itemsEntities;

  setUp(() {
    mockDatasource = LocalItemsLotDatasourceSpy();
    sut = LocalItemsLotRepositoryImpl(mockDatasource);

    itemsEntities = [
      EntityFactory.makeAdjustStockItemEntity(),
      EntityFactory.makeAdjustStockItemEntity(),
      EntityFactory.makeAdjustStockItemEntity(),
    ];

    mockDatasource.mockLoad(
      itemsEntities.map((e) => AdjustStockItemModel.fromEntity(e)).toList(),
    );
  });

  setUpAll(() {
    registerFallbackValue(
      AdjustStockItemModel.fromEntity(
        EntityFactory.makeAdjustStockItemEntity(),
      ),
    );
  });

  group('addItem', () {
    test(
      'should call datasource.addItem with the correctly mapped model',
      () async {
        await sut.addItem(itemsEntities.first);

        verify(
          () => mockDatasource.addItem(
            AdjustStockItemModel.fromEntity(itemsEntities.first),
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
            AdjustStockItemModel.fromEntity(itemsEntities.first),
          ),
        );
      },
    );
  });

  group('load', () {
    test('should return a list of entities when datasource succeeds', () async {
      final result = await sut.load();

      expect(result, itemsEntities);
    });
  });

  group('clear', () {
    test('should call datasource.clear', () async {
      await sut.clear();

      verify(() => mockDatasource.clear()).called(1);
    });
  });
}
