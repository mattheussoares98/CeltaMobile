import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/data/datasource/datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late LocalItemsLotDatasource sut;
  late MockBox mockBox;
  late List<AdjustStockItemModel> items;

  setUp(() {
    mockBox = MockBox();
    sut = LocalItemsLotDatasource(mockBox);

    // Create some fake data to use in the tests

    items = [
      EntityFactory.makeAdjustStockItemEntity(),
      EntityFactory.makeAdjustStockItemEntity(),
    ].map((e) => AdjustStockItemModel.fromEntity(e)).toList();
  });

  group('addItem', () {
    test('should call box.put with the correct key and value', () async {
      // ARRANGE
      // Tell the mock that the .put() method should complete successfully
      when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});

      // ACT
      await sut.addItem(items.first);

      // ASSERT
      // Verify that .put() was called once with the product code as the key
      // and the item's map representation as the value.
      verify(
        () => mockBox.put(items.first.ProductCode, items.first.toJson()),
      ).called(1);
    });
  });

  group('removeItem', () {
    test('should call box.delete with the correct key', () async {
      // ARRANGE
      when(() => mockBox.delete(any())).thenAnswer((_) async => {});

      // ACT
      await sut.removeItem(items.first);

      // ASSERT
      verify(() => mockBox.delete(items.first.ProductCode)).called(1);
    });
  });

  group('load', () {
    test('should return a list of items from box.values', () async {
      // ARRANGE
      final itemsMap = [items[0].toJson(), items[1].toJson()];
      // Tell the mock to return a list of maps when .values is accessed
      when(() => mockBox.values).thenReturn(itemsMap);

      // ACT
      final result = await sut.load();

      // ASSERT
      expect(result, isA<List<AdjustStockItemModel>>());
      expect(result.length, 2);
      // Check if one of the items matches our fake data
      expect(result.first.ProductCode, items.first.ProductCode);
    });
  });

  group('clear', () {
    test('should call box.clear', () async {
      // ARRANGE
      when(
        () => mockBox.clear(),
      ).thenAnswer((_) async => 0); // .clear() returns an int

      // ACT
      await sut.clear();

      // ASSERT
      verify(() => mockBox.clear()).called(1);
    });
  });
}
