import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late IEcSynchronizerDatasource sut;
  late MockHttpClient httpClient;

  final params = EntityFactory.makeEcRequestParams();
  final response = {'count': faker.randomGenerator.integer(100)};

  setUp(() {
    httpClient = MockHttpClient();
    sut = EcSynchronizerDatasource(httpClient);
  });

  group('searchCount', () {
    test(
      'should call http with correct parameters and return response on success',
      () async {
        when(
          () => httpClient.request(
            url: '${params.workingUrl}/api/Synchronizer',
            method: 'get',
            headers: params.toHeaders(),
            body: params.toMap(),
          ),
        ).thenAnswer((_) async => response);

        final result = await sut.searchCount(params);

        expect(result, response);
        verify(
          () => httpClient.request(
            url: '${params.workingUrl}/api/Synchronizer',
            method: 'get',
            headers: params.toHeaders(),
            body: params.toMap(),
          ),
        ).called(1);
        verifyNoMoreInteractions(httpClient);
      },
    );

    test('should rethrow when the http request fails', () async {
      final exception = Exception('Failed to search synchronizer count');
      when(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer',
          method: 'get',
          headers: params.toHeaders(),
          body: params.toMap(),
        ),
      ).thenThrow(exception);

      final call = sut.searchCount(params);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer',
          method: 'get',
          headers: params.toHeaders(),
          body: params.toMap(),
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });
  });
}
