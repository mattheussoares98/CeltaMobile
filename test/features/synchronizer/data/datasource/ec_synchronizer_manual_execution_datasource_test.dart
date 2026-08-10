// test/features/synchronizer/data/datasource/manual_execution_datasource_test.dart
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late IEcSynchronizerManualExecutionDatasource sut;
  late MockHttpClient httpClient;

  final params = EntityFactory.makeEcRequestParams();

  setUp(() {
    httpClient = MockHttpClient();
    sut = EcSynchronizerManualExecutionDatasource(httpClient);
  });

  group('searchManualExecutionSchedules', () {
    const searchParamsEntity = SearchManualExecutionSchedulesParametersEntity(
      enterpriseCode: 1,
    );
    final searchParamsModel =
        SearchManualExecutionSchedulesParametersModel.fromEntity(
          searchParamsEntity,
        );

    const scheduleEntity = ManualExecutionScheduleEntity(
      code: 10,
      name: 'Schedule Test',
    );
    final scheduleModel = ManualExecutionScheduleModel.fromEntity(
      scheduleEntity,
    );

    final expectedBody = {...params.toMap(), ...searchParamsModel.toJson()};

    test(
      'should post enterprise code and return list of manual execution schedules',
      () async {
        when(
          () => httpClient.request(
            url:
                '${params.workingUrl}/api/Synchronizer/SearchManualExecutionSchedules',
            method: 'post',
            headers: params.toHeaders(),
            body: expectedBody,
          ),
        ).thenAnswer((_) async => [scheduleModel.toJson()]);

        final result = await sut.searchManualExecutionSchedules(
          params,
          searchParamsModel,
        );

        expect(result, [scheduleModel]);
        verify(
          () => httpClient.request(
            url:
                '${params.workingUrl}/api/Synchronizer/SearchManualExecutionSchedules',
            method: 'post',
            headers: params.toHeaders(),
            body: expectedBody,
          ),
        ).called(1);
        verifyNoMoreInteractions(httpClient);
      },
    );

    test('should propagate request errors', () async {
      final exception = Exception('Error searching schedules');
      when(
        () => httpClient.request(
          url:
              '${params.workingUrl}/api/Synchronizer/SearchManualExecutionSchedules',
          method: 'post',
          headers: params.toHeaders(),
          body: expectedBody,
        ),
      ).thenThrow(exception);

      final call = sut.searchManualExecutionSchedules(
        params,
        searchParamsModel,
      );

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => httpClient.request(
          url:
              '${params.workingUrl}/api/Synchronizer/SearchManualExecutionSchedules',
          method: 'post',
          headers: params.toHeaders(),
          body: expectedBody,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });
  });

  group('executeManualSchedule', () {
    const executeParamsEntity = ExecuteManualScheduleParametersEntity(
      enterpriseCode: 1,
      scheduleCode: 10,
    );
    final executeParamsModel = ExecuteManualScheduleParametersModel.fromEntity(
      executeParamsEntity,
    );

    final expectedBody = {...params.toMap(), ...executeParamsModel.toJson()};

    test(
      'should post enterprise and schedule code to execute manual schedule',
      () async {
        when(
          () => httpClient.request(
            url: '${params.workingUrl}/api/Synchronizer/ExecuteManualSchedule',
            method: 'post',
            headers: params.toHeaders(),
            body: expectedBody,
          ),
        ).thenAnswer((_) async => null);

        await sut.executeManualSchedule(params, executeParamsModel);

        verify(
          () => httpClient.request(
            url: '${params.workingUrl}/api/Synchronizer/ExecuteManualSchedule',
            method: 'post',
            headers: params.toHeaders(),
            body: expectedBody,
          ),
        ).called(1);
        verifyNoMoreInteractions(httpClient);
      },
    );

    test('should propagate request errors when execution fails', () async {
      final exception = Exception('Error executing schedule');
      when(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer/ExecuteManualSchedule',
          method: 'post',
          headers: params.toHeaders(),
          body: expectedBody,
        ),
      ).thenThrow(exception);

      final call = sut.executeManualSchedule(params, executeParamsModel);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => httpClient.request(
          url: '${params.workingUrl}/api/Synchronizer/ExecuteManualSchedule',
          method: 'post',
          headers: params.toHeaders(),
          body: expectedBody,
        ),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });
  });
}
