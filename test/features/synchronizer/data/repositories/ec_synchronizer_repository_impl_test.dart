import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/data/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcSynchronizerDatasource extends Mock
    implements IEcSynchronizerDatasource {}

void main() {
  late IEcSynchronizerRepository sut;
  late MockEcSynchronizerDatasource datasource;
  late EcRequestParams params;

  setUp(() {
    datasource = MockEcSynchronizerDatasource();
    sut = EcSynchronizerRepositoryImpl(datasource);
    params = EntityFactory.makeEcRequestParams();
  });

  group('searchCount', () {
    test('should map summary models to entities', () async {
      final models = [
        SynchronizerErrorSummaryModel.fromEntity(
          EntityFactory.makeSynchronizerErrorSummaryEntity(),
        ),
        SynchronizerErrorSummaryModel.fromEntity(
          EntityFactory.makeSynchronizerErrorSummaryEntity(),
        ),
      ];
      when(
        () => datasource.searchCount(params),
      ).thenAnswer((_) async => models);

      final result = await sut.searchCount(params);

      expect(result, models.map((model) => model.toEntity()).toList());
      verify(() => datasource.searchCount(params)).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to search synchronizer count');
      when(() => datasource.searchCount(params)).thenThrow(exception);

      final call = sut.searchCount(params);

      await expectLater(call, throwsA(same(exception)));
      verify(() => datasource.searchCount(params)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('searchByKey', () {
    test(
      'should map the detail model to an entity preserving its key',
      () async {
        final model = SynchronizerErrorDetailsModel.fromEntity(
          EntityFactory.makeSynchronizerErrorDetailsEntity(),
        );
        final errorKey = model.errorKey;
        when(
          () => datasource.searchByKey(params, errorKey),
        ).thenAnswer((_) async => model);

        final result = await sut.searchByKey(params, errorKey);

        expect(result, model.toEntity());
        expect(result.errorKey, errorKey);
        verify(() => datasource.searchByKey(params, errorKey)).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );

    test('should propagate datasource errors', () async {
      final model = SynchronizerErrorDetailsModel.fromEntity(
        EntityFactory.makeSynchronizerErrorDetailsEntity(),
      );
      final errorKey = model.errorKey;
      final exception = Exception('Failed to search synchronizer details');
      when(() => datasource.searchByKey(params, errorKey)).thenThrow(exception);

      final call = sut.searchByKey(params, errorKey);

      await expectLater(call, throwsA(same(exception)));
      verify(() => datasource.searchByKey(params, errorKey)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('markCouponsToReadAgain', () {
    const codes = [123, 456];

    test('should delegate the coupon codes to the datasource', () async {
      when(
        () => datasource.markCouponsToReadAgain(params, codes),
      ).thenAnswer((_) async {});

      await sut.markCouponsToReadAgain(params, codes);

      verify(() => datasource.markCouponsToReadAgain(params, codes)).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to mark coupons for rereading');
      when(
        () => datasource.markCouponsToReadAgain(params, codes),
      ).thenThrow(exception);

      final call = sut.markCouponsToReadAgain(params, codes);

      await expectLater(call, throwsA(same(exception)));
      verify(() => datasource.markCouponsToReadAgain(params, codes)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('markSaleRequestsWithErrorToReadAgain', () {
    const codes = [123, 456];

    test('should delegate the sale request codes to the datasource', () async {
      when(
        () => datasource.markSaleRequestsWithErrorToReadAgain(params, codes),
      ).thenAnswer((_) async {});

      await sut.markSaleRequestsWithErrorToReadAgain(params, codes);

      verify(
        () => datasource.markSaleRequestsWithErrorToReadAgain(params, codes),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to mark sale requests for rereading');
      when(
        () => datasource.markSaleRequestsWithErrorToReadAgain(params, codes),
      ).thenThrow(exception);

      final call = sut.markSaleRequestsWithErrorToReadAgain(params, codes);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => datasource.markSaleRequestsWithErrorToReadAgain(params, codes),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('unmarkSaleRequestsMarked', () {
    const codes = [123, 456];

    test(
      'should delegate the marked sale request codes to the datasource',
      () async {
        when(
          () => datasource.unmarkSaleRequestsMarked(params, codes),
        ).thenAnswer((_) async {});

        await sut.unmarkSaleRequestsMarked(params, codes);

        verify(
          () => datasource.unmarkSaleRequestsMarked(params, codes),
        ).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to unmark sale requests');
      when(
        () => datasource.unmarkSaleRequestsMarked(params, codes),
      ).thenThrow(exception);

      final call = sut.unmarkSaleRequestsMarked(params, codes);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => datasource.unmarkSaleRequestsMarked(params, codes),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('insertSaleRequestsToReadAgain', () {
    const enterpriseCode = 1;
    const enterpriseCommerceSiteCode = 2;
    const saleRequestIds = ['123', '456'];

    test(
      'should delegate the sale request identifiers to the datasource',
      () async {
        when(
          () => datasource.insertSaleRequestsToReadAgain(
            params,
            enterpriseCode: enterpriseCode,
            enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
            saleRequestIds: saleRequestIds,
          ),
        ).thenAnswer((_) async {});

        await sut.insertSaleRequestsToReadAgain(
          params,
          enterpriseCode: enterpriseCode,
          enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
          saleRequestIds: saleRequestIds,
        );

        verify(
          () => datasource.insertSaleRequestsToReadAgain(
            params,
            enterpriseCode: enterpriseCode,
            enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
            saleRequestIds: saleRequestIds,
          ),
        ).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to insert sale requests to reread');
      when(
        () => datasource.insertSaleRequestsToReadAgain(
          params,
          enterpriseCode: enterpriseCode,
          enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
          saleRequestIds: saleRequestIds,
        ),
      ).thenThrow(exception);

      final call = sut.insertSaleRequestsToReadAgain(
        params,
        enterpriseCode: enterpriseCode,
        enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
        saleRequestIds: saleRequestIds,
      );

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => datasource.insertSaleRequestsToReadAgain(
          params,
          enterpriseCode: enterpriseCode,
          enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
          saleRequestIds: saleRequestIds,
        ),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('linkSaleRequestProductNotFound', () {
    const productNotFoundCode = 123;
    const productCode = 456;
    const productPackingCode = 789;

    test('should delegate the product link codes to the datasource', () async {
      when(
        () => datasource.linkSaleRequestProductNotFound(
          params,
          productNotFoundCode: productNotFoundCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
        ),
      ).thenAnswer((_) async {});

      await sut.linkSaleRequestProductNotFound(
        params,
        productNotFoundCode: productNotFoundCode,
        productCode: productCode,
        productPackingCode: productPackingCode,
      );

      verify(
        () => datasource.linkSaleRequestProductNotFound(
          params,
          productNotFoundCode: productNotFoundCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
        ),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to link the sale request product');
      when(
        () => datasource.linkSaleRequestProductNotFound(
          params,
          productNotFoundCode: productNotFoundCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
        ),
      ).thenThrow(exception);

      final call = sut.linkSaleRequestProductNotFound(
        params,
        productNotFoundCode: productNotFoundCode,
        productCode: productCode,
        productPackingCode: productPackingCode,
      );

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => datasource.linkSaleRequestProductNotFound(
          params,
          productNotFoundCode: productNotFoundCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
        ),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('deleteSaleRequestsWithError', () {
    const codes = [123, 456];

    test('should delegate the sale request codes to the datasource', () async {
      when(
        () => datasource.deleteSaleRequestsWithError(params, codes),
      ).thenAnswer((_) async {});

      await sut.deleteSaleRequestsWithError(params, codes);

      verify(
        () => datasource.deleteSaleRequestsWithError(params, codes),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to delete sale requests');
      when(
        () => datasource.deleteSaleRequestsWithError(params, codes),
      ).thenThrow(exception);

      final call = sut.deleteSaleRequestsWithError(params, codes);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => datasource.deleteSaleRequestsWithError(params, codes),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('deleteScheduleErrors', () {
    const codes = [123, 456];

    test(
      'should delegate the schedule error codes to the datasource',
      () async {
        when(
          () => datasource.deleteScheduleErrors(params, codes),
        ).thenAnswer((_) async {});

        await sut.deleteScheduleErrors(params, codes);

        verify(() => datasource.deleteScheduleErrors(params, codes)).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to delete schedule errors');
      when(
        () => datasource.deleteScheduleErrors(params, codes),
      ).thenThrow(exception);

      final call = sut.deleteScheduleErrors(params, codes);

      await expectLater(call, throwsA(same(exception)));
      verify(() => datasource.deleteScheduleErrors(params, codes)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });
}
