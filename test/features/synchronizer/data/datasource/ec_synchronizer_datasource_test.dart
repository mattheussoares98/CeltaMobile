import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late IEcSynchronizerDatasource sut;
  late MockHttpClient httpClient;

  final params = EntityFactory.makeEcRequestParams();

  setUp(() {
    httpClient = MockHttpClient();
    sut = EcSynchronizerDatasource(httpClient);
  });

  group('searchCount', () {
    final models = [
      SynchronizerErrorSummaryModel.fromEntity(
        EntityFactory.makeSynchronizerErrorSummaryEntity(),
      ),
    ];
    final response = models.map((model) => model.toJson()).toList();
    final body = {
      ...params.toMap(),
      'Operation': SynchronizerErrorSearchOperation.searchCount.value,
    };

    test('should post the typed request and return summary models', () async {
      when(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).thenAnswer((_) async => response);

      final result = await sut.searchCount(params);

      expect(result, models);
      verify(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });

    test('should propagate request errors', () async {
      final exception = Exception('Failed to search synchronizer count');
      when(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).thenThrow(exception);

      final call = sut.searchCount(params);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });
  });

  group('searchByKey', () {
    final model = SynchronizerErrorDetailsModel.fromEntity(
      EntityFactory.makeSynchronizerErrorDetailsEntity(),
    );
    final errorKey = model.errorKey;
    final body = {
      ...params.toMap(),
      'Operation': SynchronizerErrorSearchOperation.searchByKey.value,
      'ErrorKey': errorKey,
    };

    test('should post the typed request and return the detail model', () async {
      when(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).thenAnswer((_) async => json.encode(model.toJson()));

      final result = await sut.searchByKey(params, errorKey);

      expect(result, model);
      verify(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });

    test('should propagate request errors', () async {
      final exception = Exception('Failed to search synchronizer details');
      when(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).thenThrow(exception);

      final call = sut.searchByKey(params, errorKey);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });
  });

  group('markCouponsToReadAgain', () {
    const url = '/api/Synchronizer/MarkCouponsToReadAgain';

    test('should post one coupon code', () async {
      const codes = [123];
      final body = {...params.toMap(), 'Codes': codes};
      when(
        () => httpClient.request(
          url: '${params.workingUrl}$url',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).thenAnswer((_) async => null);

      await sut.markCouponsToReadAgain(params, codes);

      verify(
        () => httpClient.request(
          url: '${params.workingUrl}$url',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });

    test('should post multiple coupon codes in one request', () async {
      const codes = [123, 456, 789];
      final body = {...params.toMap(), 'Codes': codes};
      when(
        () => httpClient.request(
          url: '${params.workingUrl}$url',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).thenAnswer((_) async => null);

      await sut.markCouponsToReadAgain(params, codes);

      verify(
        () => httpClient.request(
          url: '${params.workingUrl}$url',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });

    test('should propagate request errors', () async {
      const codes = [123];
      final body = {...params.toMap(), 'Codes': codes};
      final exception = Exception('Failed to mark coupons for rereading');
      when(
        () => httpClient.request(
          url: '${params.workingUrl}$url',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).thenThrow(exception);

      final call = sut.markCouponsToReadAgain(params, codes);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => httpClient.request(
          url: '${params.workingUrl}$url',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });
  });

  group('deleteScheduleErrors', () {
    const codes = [123, 456];
    const url = '/api/Synchronizer/DeleteScheduleErrors';
    final body = {...params.toMap(), 'Codes': codes};

    test('should post all schedule error codes in one request', () async {
      when(
        () => httpClient.request(
          url: '${params.workingUrl}$url',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).thenAnswer((_) async => null);

      await sut.deleteScheduleErrors(params, codes);

      verify(
        () => httpClient.request(
          url: '${params.workingUrl}$url',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });

    test('should propagate request errors', () async {
      final exception = Exception('Failed to delete schedule errors');
      when(
        () => httpClient.request(
          url: '${params.workingUrl}$url',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).thenThrow(exception);

      final call = sut.deleteScheduleErrors(params, codes);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => httpClient.request(
          url: '${params.workingUrl}$url',
          method: 'post',
          headers: params.toHeaders(),
          body: body,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });
  });
}
