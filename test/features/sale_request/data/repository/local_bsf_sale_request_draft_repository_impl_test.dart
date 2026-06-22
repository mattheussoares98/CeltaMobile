import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/data/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockLocalBSFSaleRequestDraftDatasource extends Mock
    implements ILocalBSFSaleRequestDraftDatasource {}

void main() {
  late ILocalBSFSaleRequestDraftRepository sut;
  late MockLocalBSFSaleRequestDraftDatasource mockDatasource;

  late BSFSaleRequestEntity saleRequestEntity;
  late int enterpriseCode;
  late int requestTypeCode;

  setUp(() {
    mockDatasource = MockLocalBSFSaleRequestDraftDatasource();
    sut = LocalBSFSaleRequestDraftRepositoryImpl(mockDatasource);

    saleRequestEntity = EntityFactory.makeBSFSaleRequestEntity();
    enterpriseCode = faker.randomGenerator.integer(300, min: 201);
    requestTypeCode = faker.randomGenerator.integer(100, min: 1);
  });

  group('Save', () {
    test('Should forward call with mapped BSFSaleRequestModel to datasource', () async {
      final model = BSFSaleRequestModel.fromEntity(saleRequestEntity);
      when(() => mockDatasource.save(
            model,
            enterpriseCode: enterpriseCode,
            requestTypeCode: requestTypeCode,
          )).thenAnswer((_) async {});

      await sut.save(
        saleRequestEntity,
        enterpriseCode: enterpriseCode,
        requestTypeCode: requestTypeCode,
      );

      verify(() => mockDatasource.save(
            model,
            enterpriseCode: enterpriseCode,
            requestTypeCode: requestTypeCode,
          )).called(1);
    });
  });

  group('Load', () {
    test('Should return entity mapped from load result when datasource returns model', () async {
      final model = BSFSaleRequestModel.fromEntity(saleRequestEntity);
      when(() => mockDatasource.load(
            enterpriseCode: enterpriseCode,
            requestTypeCode: requestTypeCode,
          )).thenAnswer((_) async => model);

      final result = await sut.load(
        enterpriseCode: enterpriseCode,
        requestTypeCode: requestTypeCode,
      );

      expect(result, model.toEntity());
      verify(() => mockDatasource.load(
            enterpriseCode: enterpriseCode,
            requestTypeCode: requestTypeCode,
          )).called(1);
    });

    test('Should return null when datasource returns null', () async {
      when(() => mockDatasource.load(
            enterpriseCode: enterpriseCode,
            requestTypeCode: requestTypeCode,
          )).thenAnswer((_) async => null);

      final result = await sut.load(
        enterpriseCode: enterpriseCode,
        requestTypeCode: requestTypeCode,
      );

      expect(result, isNull);
      verify(() => mockDatasource.load(
            enterpriseCode: enterpriseCode,
            requestTypeCode: requestTypeCode,
          )).called(1);
    });
  });

  group('Clear', () {
    test('Should forward clear request to datasource', () async {
      when(() => mockDatasource.clear(
            enterpriseCode: enterpriseCode,
            requestTypeCode: requestTypeCode,
          )).thenAnswer((_) async {});

      await sut.clear(
        enterpriseCode: enterpriseCode,
        requestTypeCode: requestTypeCode,
      );

      verify(() => mockDatasource.clear(
            enterpriseCode: enterpriseCode,
            requestTypeCode: requestTypeCode,
          )).called(1);
    });
  });
}
