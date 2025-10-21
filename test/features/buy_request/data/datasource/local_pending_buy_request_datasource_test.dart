import 'package:celta_intelligence/core/infraestructure/infrastructure.dart';
import 'package:celta_intelligence/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/buy_request/data/models/models.dart';
import 'package:celta_intelligence/features/buy_request/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalPendingBuyRequestDatasource sut;

  late MockBox hive;

  late PendingBuyRequestEntity entity;

  void initSut() {
    sut = LocalPendingBuyRequestDatasource(hive);
  }

  void initInjections() {
    hive = MockBox();
  }

  void mockSuccess() {
    hive.mockGet(
      DatabaseConstants.buyRequest.name,
      PendingBuyRequestModel.fromEntity(entity).toJson(),
    );
  }

  void initEntities() {
    entity = EntityFactory.makePendingBuyRequestEntity();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Update', () {
    test('Should call hive with correct params', () async {
      await sut.update(PendingBuyRequestModel.fromEntity(entity));

      verify(
        () => hive.put(
          DatabaseConstants.buyRequest.name,
          PendingBuyRequestModel.fromEntity(entity).toJson(),
        ),
      ).called(1);
    });
  });
  group('Get', () {
    test('Should return correct value when is not null', () async {
      expect(await sut.load(), PendingBuyRequestModel.fromEntity(entity));

      verify(() => hive.get(DatabaseConstants.buyRequest.name)).called(1);
    });

    test('Should return correct value when returns null', () async {
      hive.mockGet(DatabaseConstants.buyRequest.name, null);

      expect(await sut.load(), null);
    });
  });
}
