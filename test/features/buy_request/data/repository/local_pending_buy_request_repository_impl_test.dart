import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/buy_request/data/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalPendingBuyRequestRepository sut;

  late LocalPendingBuyRequestDatasourceSpy datasource;

  late PendingBuyRequestEntity entity;
  late int enterpriseCode;

  void initSut() {
    sut = LocalPendingBuyRequestRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = LocalPendingBuyRequestDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(PendingBuyRequestModel.fromEntity(entity));
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

  setUpAll(() {
    registerFallbackValue(
      PendingBuyRequestModel.fromEntity(
        EntityFactory.makePendingBuyRequestEntity(),
      ),
    );
  });

  group('Update', () {
    test('should behave correctly on success', () async {
      await sut.update(entity, enterpriseCode);

      verify(
        () => datasource.update(
          PendingBuyRequestModel.fromEntity(entity),
          enterpriseCode,
        ),
      ).called(1);

      verifyNoMoreInteractions(datasource);
    });
  });

  group('Load', () {
    test('should behave correctly on success', () async {
      final result = await sut.load(enterpriseCode);

      expect(result, entity);

      verify(() => datasource.load(enterpriseCode)).called(1);

      verifyNoMoreInteractions(datasource);
    });

    test('should return null when doesnt has local data', () async {
      datasource.mockLoad(null);

      final result = await sut.load(enterpriseCode);

      expect(result, null);

      verify(() => datasource.load(enterpriseCode)).called(1);

      verifyNoMoreInteractions(datasource);
    });
  });
}
