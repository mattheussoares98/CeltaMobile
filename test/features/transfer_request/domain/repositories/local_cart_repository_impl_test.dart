import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/transfer_request/data/models/models.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/domain/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// 1. Create a Mock for the datasource dependency
class MockLocalCartDatasource extends Mock implements ILocalCartDatasource {}

void main() {
  late ILocalCartRepository sut;
  late MockLocalCartDatasource mockDatasource;
  late DraftKey fakeDraftKey;
  late TransferRequestProductItemEntity fakeEntity;

  setUpAll(() {
    // Register custom types for mocktail's `any()` and `captureAny()`
    registerFallbackValue(
      const DraftKey(
        requestTypeCode: 0,
        enterpriseOrigin: 0,
        enterpriseDestinyCode: 0,
      ),
    );
    registerFallbackValue(
      TransferRequestProductItemModel.fromEntity(
        TransferRequestProductItemEntity(
          product: EntityFactory.makeProductEntity(),
          quantity: faker.randomGenerator.decimal(),
          value: faker.randomGenerator.decimal(),
        ),
      ),
    );
  });

  setUp(() {
    mockDatasource = MockLocalCartDatasource();
    sut = LocalCartRepositoryImpl(mockDatasource);

    // Create fake data
    fakeDraftKey = const DraftKey(
      requestTypeCode: 1,
      enterpriseOrigin: 1,
      enterpriseDestinyCode: 2,
    );
    fakeEntity = TransferRequestProductItemEntity(
      product: EntityFactory.makeProductEntity(),
      quantity: faker.randomGenerator.decimal(),
      value: faker.randomGenerator.decimal(),
    );
  });

  group('load', () {
    test('should call datasource.load and map models to entities', () async {
      // ARRANGE
      final fakeModelList = [
        TransferRequestProductItemModel.fromEntity(fakeEntity),
      ];
      when(
        () => mockDatasource.load(any()),
      ).thenAnswer((_) async => fakeModelList);

      // ACT
      final result = await sut.load(fakeDraftKey);

      // ASSERT
      expect(result, isA<List<TransferRequestProductItemEntity>>());
      expect(result.length, 1);
      expect(
        result.first.product.ProductPackingCode,
        fakeEntity.product.ProductPackingCode,
      );
      verify(() => mockDatasource.load(fakeDraftKey)).called(1);
    });
  });

  group('addItem', () {
    test('should map entity to model and call datasource.addItem', () async {
      // ARRANGE
      when(() => mockDatasource.addItem(any(), any())).thenAnswer((_) async {});
      when(() => mockDatasource.load(any())).thenAnswer((_) async => []);

      // ACT
      await sut.addItem(fakeDraftKey, fakeEntity);

      // ASSERT
      verify(
        () => mockDatasource.addItem(
          fakeDraftKey,
          TransferRequestProductItemModel.fromEntity(fakeEntity),
        ),
      ).called(1);
    });
    test(
      'should update the quantity when add a product that already exists',
      () async {
        // ARRANGE
        when(
          () => mockDatasource.addItem(any(), any()),
        ).thenAnswer((_) async {});
        when(() => mockDatasource.load(any())).thenAnswer(
          (_) async => [TransferRequestProductItemModel.fromEntity(fakeEntity)],
        );

        // ACT
        await sut.addItem(fakeDraftKey, fakeEntity.copyWith(quantity: 10));

        // ASSERT
        verify(
          () => mockDatasource.addItem(
            fakeDraftKey,
            TransferRequestProductItemModel.fromEntity(
              fakeEntity.copyWith(quantity: fakeEntity.quantity + 10),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('removeItem', () {
    test('should map entity to model and call datasource.removeItem', () async {
      // ARRANGE
      when(
        () => mockDatasource.removeItem(any(), any()),
      ).thenAnswer((_) async {});

      // ACT
      await sut.removeItem(fakeDraftKey, fakeEntity);

      // ASSERT
      final captured = verify(
        () => mockDatasource.removeItem(fakeDraftKey, captureAny()),
      ).captured;
      final capturedModel = captured.first as TransferRequestProductItemModel;

      expect(capturedModel.product.ProductCode, fakeEntity.product.ProductCode);
    });
  });

  group('clear', () {
    test('should call datasource.clear with the correct key', () async {
      // ARRANGE
      when(() => mockDatasource.clear(any())).thenAnswer((_) async {});

      // ACT
      await sut.clear(fakeDraftKey);

      // ASSERT
      verify(() => mockDatasource.clear(fakeDraftKey)).called(1);
    });
  });
}
