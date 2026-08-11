// test/features/synchronizer/data/repositories/ec_synchronizer_manual_execution_repository_impl_test.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/data/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcSynchronizerManualExecutionDatasource extends Mock
    implements IEcSynchronizerManualExecutionDatasource {}

void main() {
  late IEcSynchronizerManualExecutionRepository sut;
  late MockEcSynchronizerManualExecutionDatasource datasource;
  late EcRequestParams params;

  setUp(() {
    datasource = MockEcSynchronizerManualExecutionDatasource();
    sut = EcSynchronizerManualExecutionRepositoryImpl(datasource);
    params = EntityFactory.makeEcRequestParams();
  });

  group('searchManualExecutionEnterprises', () {
    const searchParamsEntity = SearchManualExecutionEnterprisesParamsEntity(
      enterpriseCodes: [1],
    );
    final searchParamsModel =
        SearchManualExecutionEnterprisesParametersModel.fromEntity(
          searchParamsEntity,
        );

    const enterpriseEntity = ManualExecutionEnterpriseEntity(
      code: 1,
      name: 'Enterprise Test',
    );
    final enterpriseModel = ManualExecutionEnterpriseModel.fromEntity(
      enterpriseEntity,
    );

    test('should map returned models to entities', () async {
      when(
        () => datasource.searchManualExecutionEnterprises(
          params,
          searchParamsModel,
        ),
      ).thenAnswer((_) async => [enterpriseModel]);

      final result = await sut.searchManualExecutionEnterprises(
        params,
        searchParamsEntity,
      );

      expect(result, [enterpriseEntity]);
      verify(
        () => datasource.searchManualExecutionEnterprises(
          params,
          searchParamsModel,
        ),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors when search fails', () async {
      final exception = Exception('Failed searching enterprises');
      when(
        () => datasource.searchManualExecutionEnterprises(
          params,
          searchParamsModel,
        ),
      ).thenThrow(exception);

      final call = sut.searchManualExecutionEnterprises(
        params,
        searchParamsEntity,
      );

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => datasource.searchManualExecutionEnterprises(
          params,
          searchParamsModel,
        ),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });
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

    test('should map returned models to entities', () async {
      when(
        () => datasource.searchManualExecutionSchedules(
          params,
          searchParamsModel,
        ),
      ).thenAnswer((_) async => [scheduleModel]);

      final result = await sut.searchManualExecutionSchedules(
        params,
        searchParamsEntity,
      );

      expect(result, [scheduleEntity]);
      verify(
        () => datasource.searchManualExecutionSchedules(
          params,
          searchParamsModel,
        ),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors when search fails', () async {
      final exception = Exception('Failed searching schedules');
      when(
        () => datasource.searchManualExecutionSchedules(
          params,
          searchParamsModel,
        ),
      ).thenThrow(exception);

      final call = sut.searchManualExecutionSchedules(
        params,
        searchParamsEntity,
      );

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => datasource.searchManualExecutionSchedules(
          params,
          searchParamsModel,
        ),
      ).called(1);
      verifyNoMoreInteractions(datasource);
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

    test('should call executeManualSchedule on datasource', () async {
      when(
        () => datasource.executeManualSchedule(params, executeParamsModel),
      ).thenAnswer((_) async => Future.value());

      await sut.executeManualSchedule(params, executeParamsEntity);

      verify(
        () => datasource.executeManualSchedule(params, executeParamsModel),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors when execute fails', () async {
      final exception = Exception('Failed executing schedule');
      when(
        () => datasource.executeManualSchedule(params, executeParamsModel),
      ).thenThrow(exception);

      final call = sut.executeManualSchedule(params, executeParamsEntity);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => datasource.executeManualSchedule(params, executeParamsModel),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });
}
