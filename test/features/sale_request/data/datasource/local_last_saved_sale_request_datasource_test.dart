import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalLastSavedSaleRequestDatasource sut;

  late MockBox hive;

  late LastSavedSaleRequestEntity entity;
  late int enterpriseCode;
  const String keyPrefix = 'last_saved_sale_request_';

  void initSut() {
    sut = LocalLastSavedSaleRequestDatasource(hive);
  }

  void initInjections() {
    hive = MockBox();
  }

  void mockSuccess() {
    hive.mockGet(
      '$keyPrefix$enterpriseCode',
      SoapLastSavedSaleRequestModel.fromEntity(entity).toJson(),
    );
  }

  void initEntities() {
    enterpriseCode = faker.randomGenerator.integer(100);
    entity = LastSavedSaleRequestEntity(
      pendingSaleRequestEntity: EntityFactory.makePendingSaleRequestEntity(),
      saleRequestNumber: faker.randomGenerator.integer(100).toString(),
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
        value: SoapLastSavedSaleRequestModel.fromEntity(entity),
        enterpriseCode: enterpriseCode,
      );

      verify(
        () => hive.put(
          '$keyPrefix$enterpriseCode',
          SoapLastSavedSaleRequestModel.fromEntity(entity).toJson(),
        ),
      ).called(1);
    });
  });
  group('Get', () {
    test('Should return correct value when is not null', () async {
      expect(
        await sut.load(enterpriseCode),
        SoapLastSavedSaleRequestModel.fromEntity(entity),
      );

      verify(() => hive.get('$keyPrefix$enterpriseCode')).called(1);
    });

    test('Should return correct value when returns null', () async {
      hive.mockGet('$keyPrefix$enterpriseCode', null);

      expect(await sut.load(enterpriseCode), null);
    });
  });
}
