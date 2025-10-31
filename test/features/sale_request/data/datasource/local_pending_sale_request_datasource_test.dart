import 'package:celta_intelligence/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/sale_request/data/models/models.dart';
import 'package:celta_intelligence/features/sale_request/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalPendingSaleRequestDatasource sut;

  late MockBox hive;

  late PendingSaleRequestEntity entity;
  late CartProductEntity firstProduct;
  late CartProductEntity secondProduct;
  late CartProductEntity thirdProduct;
  late int enterpriseCode;

  void initSut() {
    sut = LocalPendingSaleRequestDatasource(hive);
  }

  void initInjections() {
    hive = MockBox();
  }

  void mockSuccess() {
    hive.mockGet(
      enterpriseCode,
      PendingSaleRequestModel.fromEntity(entity).toJson(),
    );
  }

  void initEntities() {
    firstProduct = EntityFactory.makeCartProductEntity();
    secondProduct = EntityFactory.makeCartProductEntity();
    thirdProduct = EntityFactory.makeCartProductEntity();
    enterpriseCode = faker.randomGenerator.integer(300, min: 201);
    entity = PendingSaleRequestEntity(
      cart: <ProductPackingCode, CartProductEntity>{
        firstProduct.ProductPackingCode: firstProduct,
        secondProduct.ProductPackingCode: secondProduct,
        thirdProduct.ProductPackingCode: thirdProduct,
      },
      customer: EntityFactory.makeCustomerEntity(),
      covenant: EntityFactory.makeCustomerCovenantEntity(),
    );
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Save', () {
    test('Should behave correctly', () async {
      await sut.save(
        PendingSaleRequestModel.fromEntity(entity),
        enterpriseCode,
      );

      verify(
        () => hive.put(
          enterpriseCode,
          PendingSaleRequestModel.fromEntity(entity).toJson(),
        ),
      ).called(1);
    });
  });
  group('Get', () {
    test('Should return correct value when is not null', () async {
      expect(
        await sut.load(enterpriseCode),
        PendingSaleRequestModel.fromEntity(entity),
      );

      verify(() => hive.get(enterpriseCode)).called(1);
    });

    test('Should return correct value when returns null', () async {
      hive.mockGet(enterpriseCode, null);

      expect(await sut.load(enterpriseCode), null);
    });
  });
}
