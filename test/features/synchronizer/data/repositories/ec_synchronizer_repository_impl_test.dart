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

  group('deleteScheduleErrors', () {
    const codes = [123, 456];

    test('should delegate the schedule error codes to the datasource', () async {
      when(
        () => datasource.deleteScheduleErrors(params, codes),
      ).thenAnswer((_) async {});

      await sut.deleteScheduleErrors(params, codes);

      verify(() => datasource.deleteScheduleErrors(params, codes)).called(1);
      verifyNoMoreInteractions(datasource);
    });

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
