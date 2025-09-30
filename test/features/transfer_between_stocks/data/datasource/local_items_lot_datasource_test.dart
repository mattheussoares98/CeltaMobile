import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/data/datasource/datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late LocalItemsLotDatasource sut;
  late MockBox mockBox;
  late AdjustStockItemModel fakeItem1;
  late AdjustStockItemModel fakeItem2;

  setUp(() {
    mockBox = MockBox();
    sut = LocalItemsLotDatasource(mockBox);

    fakeItem1 = AdjustStockItemModel.fromEntity(
      EntityFactory.makeAdjustStockItemEntity().copyWith(
        EnterpriseCode: 1,
        ProductPackingCode: 101,
      ),
    );
    fakeItem2 = AdjustStockItemModel.fromEntity(
      EntityFactory.makeAdjustStockItemEntity().copyWith(
        EnterpriseCode: 1,
        ProductPackingCode: 102,
      ),
    );
  });

  const lotKey = 'items_lot';

  group('load', () {
    test('should return a list of items for the correct enterprise', () async {
      // ARRANGE
      final initialMap = {
        '1': {
          // enterpriseCode '1'
          '101': fakeItem1.toJson(),
          '102': fakeItem2.toJson(),
        },
        '2': {
          // enterpriseCode '2'
          '201': {'ProductPackingCode': 201, 'EnterpriseCode': 2 /* ... */},
        },
      };
      when(
        () => mockBox.get(lotKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn(initialMap);

      // ACT
      final result = await sut.load(1); // Load items for enterprise 1

      // ASSERT
      expect(result.length, 2);
      expect(result.any((item) => item.ProductPackingCode == 101), isTrue);
    });

    test('should return an empty list if enterprise has no lot', () async {
      // ARRANGE
      when(
        () => mockBox.get(lotKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn({});

      // ACT
      final result = await sut.load(1);

      // ASSERT
      expect(result, isEmpty);
    });
  });

  group('addItem', () {
    test('should add a new item to an existing enterprise lot', () async {
      // ARRANGE
      final initialMap = {
        '1': {'101': fakeItem1.toJson()},
      };
      when(
        () => mockBox.get(lotKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn(initialMap);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // ACT
      await sut.addItem(fakeItem2);

      // ASSERT
      final captured = verify(() => mockBox.put(lotKey, captureAny())).captured;
      final finalMap = captured.first as Map;
      // Check that the new map for enterprise '1' now contains both products
      expect(finalMap['1']['102'], isNotNull);
      expect(finalMap['1'].length, 2);
    });
  });

  group('removeItem', () {
    test('should remove an item from an enterprise lot', () async {
      // ARRANGE
      final initialMap = {
        '1': {'101': fakeItem1.toJson(), '102': fakeItem2.toJson()},
      };
      when(
        () => mockBox.get(lotKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn(initialMap);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // ACT
      await sut.removeItem(fakeItem1);

      // ASSERT
      final captured = verify(() => mockBox.put(lotKey, captureAny())).captured;
      final finalMap = captured.first as Map;
      // Check that the map for enterprise '1' now only contains one product
      expect(finalMap['1']['101'], isNull);
      expect(finalMap['1'].length, 1);
    });
  });

  group('clear', () {
    test('should remove the entire lot for a specific enterprise', () async {
      // ARRANGE
      final initialMap = {
        '1': {'101': fakeItem1.toJson()},
        '2': {
          '201': {'ProductCode': 201 /* ... */},
        },
      };
      when(
        () => mockBox.get(lotKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn(initialMap);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // ACT
      await sut.clear(1); // Clear lot for enterprise 1

      // ASSERT
      final captured = verify(() => mockBox.put(lotKey, captureAny())).captured;
      final finalMap = captured.first as Map;
      // Check that the entry for enterprise '1' is gone, but '2' remains
      expect(finalMap.containsKey('1'), isFalse);
      expect(finalMap.containsKey('2'), isTrue);
    });
  });
}
