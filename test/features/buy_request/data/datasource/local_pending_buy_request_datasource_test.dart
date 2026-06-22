import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalPendingBuyRequestDatasource sut;

  late MockBox hive;

  late PendingBuyRequestEntity entity;
  late int enterpriseCode;

  void initSut() {
    sut = LocalPendingBuyRequestDatasource(hive);
  }

  void initInjections() {
    hive = MockBox();
  }

  void mockSuccess() {
    hive.mockGet(
      'pending_buy_request_$enterpriseCode',
      PendingBuyRequestModel.fromEntity(entity).toJson(),
    );
  }

  void initEntities() {
    entity = EntityFactory.makePendingBuyRequestEntity();
    enterpriseCode = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Update', () {
    test('Should call hive with correct params', () async {
      final newEnterpriseCode = faker.randomGenerator.integer(100);

      await sut.update(
        PendingBuyRequestModel.fromEntity(entity),
        newEnterpriseCode,
      );

      verify(
        () => hive.put(
          'pending_buy_request_$newEnterpriseCode',
          PendingBuyRequestModel.fromEntity(entity).toJson(),
        ),
      ).called(1);
    });
  });
  group('Get', () {
    test('Should return correct value when is not null', () async {
      expect(
        await sut.load(enterpriseCode),
        PendingBuyRequestModel.fromEntity(entity),
      );

      verify(() => hive.get('pending_buy_request_$enterpriseCode')).called(1);
    });

    test('Should return correct value when returns null', () async {
      hive.mockGet('pending_buy_request_$enterpriseCode', null);

      expect(await sut.load(enterpriseCode), null);
    });
  });
}
