import 'package:celta_intelligence/features/reports/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/reports/data/models/models.dart';
import 'package:celta_intelligence/features/reports/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapExecuteOrDownloadScheduleDatasourceSpy extends Mock
    implements ISoapExecuteOrDownloadScheduleDatasource {
  void mockLoad(List<ReportScheduleExecutionsModel> response) => when(
    () => this.executeOrDownloadSchedule(
      baseUrl: any(named: 'baseUrl'),
      crossIdentity: any(named: 'crossIdentity'),
      reportScheduleCode: any(named: 'reportScheduleCode'),
      execute: any(named: 'execute'),
      sendEmailOnExecution: any(named: 'sendEmailOnExecution'),
      downloadParams: any(named: 'downloadParams'),
    ),
  ).thenAnswer((_) async => response);
}

void main() {
  late ISoapExecuteOrDownloadScheduleRepository sut;
  late SoapExecuteOrDownloadScheduleDatasourceSpy mockDatasource;

  late String baseUrl;
  late String crossIdentity;
  late List<ReportScheduleExecutionsModel> reportScheduleExecutionsModels;
  late int reportScheduleCode;
  late bool execute;
  late bool sendEmailOnExecution;
  late DownloadParams downloadParams;

  setUp(() {
    mockDatasource = SoapExecuteOrDownloadScheduleDatasourceSpy();
    sut = SoapExecuteOrDownloadScheduleRepositoryImpl(mockDatasource);

    reportScheduleExecutionsModels = [
      EntityFactory.makeReportScheduleExecutionsEntity(),
      EntityFactory.makeReportScheduleExecutionsEntity(),
      EntityFactory.makeReportScheduleExecutionsEntity(),
    ].map((e) => ReportScheduleExecutionsModel.fromEntity(e)).toList();

    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    reportScheduleCode = faker.randomGenerator.integer(100);
    execute = faker.randomGenerator.boolean();
    sendEmailOnExecution = faker.randomGenerator.boolean();
    downloadParams = DownloadParams(
      DownloadLastExecution: faker.randomGenerator.boolean(),
      DownloadPdf: faker.randomGenerator.boolean(),
      DownloadXlsx: faker.randomGenerator.boolean(),
    );

    mockDatasource.mockLoad(reportScheduleExecutionsModels);
  });

  setUpAll(() {
    registerFallbackValue(
      DownloadParams(
        DownloadLastExecution: faker.randomGenerator.boolean(),
        DownloadPdf: faker.randomGenerator.boolean(),
        DownloadXlsx: faker.randomGenerator.boolean(),
      ),
    );
  });

  test('should behave correctly on success', () async {
    final response = await sut.executeOrDownloadSchedule(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      reportScheduleCode: reportScheduleCode,
      execute: execute,
      sendEmailOnExecution: sendEmailOnExecution,
      downloadParams: downloadParams,
    );

    expect(
      response,
      reportScheduleExecutionsModels.map((e) => e.toEntity()).toList(),
    );

    verify(
      () => mockDatasource.executeOrDownloadSchedule(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        reportScheduleCode: reportScheduleCode,
        execute: execute,
        sendEmailOnExecution: sendEmailOnExecution,
        downloadParams: DownloadParams(
          DownloadLastExecution:
              downloadParams.DownloadPdf || downloadParams.DownloadXlsx,
          DownloadPdf: downloadParams.DownloadPdf,
          DownloadXlsx: downloadParams.DownloadXlsx,
        ),
      ),
    ).called(1);
  });
}
