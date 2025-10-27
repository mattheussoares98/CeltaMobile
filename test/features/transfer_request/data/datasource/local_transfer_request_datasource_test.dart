import 'package:celta_intelligence/core/infraestructure/database_constants.dart';
import 'package:celta_intelligence/features/transfer_request/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/transfer_request/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalTransferRequestDatasource sut;
  late MockBox mockBox;
  late DraftKey fakeDraftKey;
  late List<TransferRequestProductItemModel> fakeItems;

  // Use the public key from your SUT
  final draftsKey = DatabaseConstants.transferRequest.name;

  setUp(() {
    mockBox = MockBox();
    sut = LocalTransferRequestDatasource(mockBox);

    fakeDraftKey = DraftKey(
      requestTypeCode: faker.randomGenerator.integer(100),
      enterpriseOrigin: faker.randomGenerator.integer(100),
      enterpriseDestinyCode: faker.randomGenerator.integer(100),
    );
    fakeItems = [
      TransferRequestProductItemEntity(
        product: EntityFactory.makeProductEntity(),
        quantity: faker.randomGenerator.decimal(),
        value: faker.randomGenerator.decimal(),
      ),
      TransferRequestProductItemEntity(
        product: EntityFactory.makeProductEntity(),
        quantity: faker.randomGenerator.decimal(),
        value: faker.randomGenerator.decimal(),
      ),
    ].map((e) => TransferRequestProductItemModel.fromEntity(e)).toList();
  });

  group('load', () {
    test('should return a list of items for a specific draftKey', () async {
      // ARRANGE
      final initialMap = {
        fakeDraftKey.toMapKey(): {
          fakeItems[0].product.ProductPackingCode: fakeItems[0].toJson(),
          fakeItems[1].product.ProductPackingCode: fakeItems[1].toJson(),
        },
      };
      when(
        () => mockBox.get(draftsKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn(initialMap);

      // ACT
      final result = await sut.load(fakeDraftKey);

      // ASSERT
      expect(result, fakeItems);
    });

    test('should return an empty list if draftKey does not exist', () async {
      // ARRANGE
      when(
        () => mockBox.get(draftsKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn({});

      // ACT
      final result = await sut.load(fakeDraftKey);

      // ASSERT
      expect(result, isEmpty);
    });
  });

  group('addItem', () {
    test('should call box.put with the newly added item', () async {
      // ARRANGE
      when(
        () => mockBox.get(draftsKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn({});
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // ACT
      await sut.addItem(fakeDraftKey, fakeItems[0]);

      verify(
        () => mockBox.put(draftsKey, {
          fakeDraftKey.toMapKey(): {
            fakeItems[0].product.ProductPackingCode.toString(): fakeItems[0]
                .toJson(),
          },
        }),
      ).called(1);
    });

    test('should update an existing item', () async {
      // ARRANGE
      final initialMap = {
        fakeDraftKey.toMapKey(): {
          fakeItems[0].product.ProductPackingCode.toString(): fakeItems[0]
              .toJson(),
        },
      };
      when(
        () => mockBox.get(draftsKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn(initialMap);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // ACT
      final updatedItem = fakeItems[0].toEntity().copyWith(quantity: 99);
      await sut.addItem(
        fakeDraftKey,
        TransferRequestProductItemModel.fromEntity(updatedItem),
      );

      verify(
        () => mockBox.put(draftsKey, {
          fakeDraftKey.toMapKey(): {
            updatedItem.product.ProductPackingCode
                .toString(): TransferRequestProductItemModel.fromEntity(
              updatedItem,
            ).toJson(),
          },
        }),
      ).called(1);
    });
  });

  group('removeItem', () {
    test('should call box.put with the item removed', () async {
      // ARRANGE
      final initialMap = {
        fakeDraftKey.toMapKey(): {
          fakeItems[0].product.ProductPackingCode.toString(): fakeItems[0]
              .toJson(),
        },
      };
      when(
        () => mockBox.get(draftsKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn(initialMap);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // ACT
      await sut.removeItem(fakeDraftKey, fakeItems[0]);

      verify(
        () => mockBox.put(draftsKey, {fakeDraftKey.toMapKey(): {}}),
      ).called(1);
    });
  });

  group('clear', () {
    test('should remove the entire draft for the given key', () async {
      // ARRANGE
      final initialMap = {
        fakeDraftKey.toMapKey(): {
          fakeItems[0].product.ProductPackingCode: fakeItems[0].toJson(),
        },
        'another-key': {'999': {}},
      };
      when(
        () => mockBox.get(draftsKey, defaultValue: any(named: 'defaultValue')),
      ).thenReturn(initialMap);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // ACT
      await sut.clear(fakeDraftKey);

      // ASSERT
      final captured = verify(
        () => mockBox.put(draftsKey, captureAny()),
      ).captured;
      final finalMap = captured.first as Map<String, dynamic>;
      expect(finalMap.containsKey(fakeDraftKey.toMapKey()), isFalse);
      expect(finalMap.containsKey('another-key'), isTrue);
    });
  });
}
