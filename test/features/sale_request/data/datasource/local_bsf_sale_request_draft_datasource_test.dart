import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalBSFSaleRequestDraftDatasource sut;
  late MockBox hiveBox;

  late BSFSaleRequestEntity entity;
  late int enterpriseCode;
  late int requestTypeCode;
  late String databaseKey;

  void initInjections() {
    hiveBox = MockBox();
  }

  void initSut() {
    sut = LocalBSFSaleRequestDraftDatasource(hiveBox);
  }

  void initEntities() {
    entity = EntityFactory.makeBSFSaleRequestEntity();
    enterpriseCode = faker.randomGenerator.integer(300, min: 201);
    requestTypeCode = faker.randomGenerator.integer(100, min: 1);
    databaseKey = 'bsf_draft_${enterpriseCode}_$requestTypeCode';
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
  });

  group('Save', () {
    test(
      'Should persist the draft mapped to JSON in Hive Box under correct key',
      () async {
        final model = BSFSaleRequestModel.fromEntity(entity);

        await sut.save(
          model,
          enterpriseCode: enterpriseCode,
          requestTypeCode: requestTypeCode,
        );

        verify(() => hiveBox.put(databaseKey, model.toJson())).called(1);
      },
    );
  });

  group('Load', () {
    test(
      'Should return correct BSFSaleRequestModel when entry exists in Hive Box',
      () async {
        final model = BSFSaleRequestModel.fromEntity(entity);
        hiveBox.mockGet(databaseKey, model.toJson());

        final result = await sut.load(
          enterpriseCode: enterpriseCode,
          requestTypeCode: requestTypeCode,
        );

        expect(result, model);
        verify(() => hiveBox.get(databaseKey)).called(1);
      },
    );

    test('Should return null when entry does not exist in Hive Box', () async {
      hiveBox.mockGet(databaseKey, null);

      final result = await sut.load(
        enterpriseCode: enterpriseCode,
        requestTypeCode: requestTypeCode,
      );

      expect(result, isNull);
      verify(() => hiveBox.get(databaseKey)).called(1);
    });
  });

  group('Clear', () {
    test(
      'Should remove the draft entry from Hive Box under correct key',
      () async {
        await sut.clear(
          enterpriseCode: enterpriseCode,
          requestTypeCode: requestTypeCode,
        );

        verify(() => hiveBox.delete(databaseKey)).called(1);
      },
    );
  });
}
