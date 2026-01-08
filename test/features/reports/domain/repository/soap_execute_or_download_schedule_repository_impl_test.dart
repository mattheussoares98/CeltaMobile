import 'package:celta_intelligence/features/reports/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/reports/data/models/models.dart';
import 'package:celta_intelligence/features/reports/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class SoapExecuteOrDownloadScheduleDatasourceSpy extends Mock
    implements ISoapExecuteOrDownloadScheduleDatasource {
  void mockLoad(List<ScheduleExecutionsModel> response) => when(
    () => this.executeOrDownloadSchedule(
      urlInUse: any(named: 'urlInUse'),
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

  late String urlInUse;
  late String crossIdentity;
  late List<ScheduleExecutionsModel> reportScheduleExecutionsModels;
  late int reportScheduleCode;
  late bool downloadPdf;
  late bool downloadXlsx;

  setUp(() {
    mockDatasource = SoapExecuteOrDownloadScheduleDatasourceSpy();
    sut = SoapExecuteOrDownloadScheduleRepositoryImpl(mockDatasource);

    reportScheduleExecutionsModels = [
      EntityFactory.makeScheduleExecutionsEntity(),
      EntityFactory.makeScheduleExecutionsEntity(),
      EntityFactory.makeScheduleExecutionsEntity(),
    ].map((e) => ScheduleExecutionsModel.fromEntity(e)).toList();

    urlInUse = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    reportScheduleCode = faker.randomGenerator.integer(100);
    downloadPdf = faker.randomGenerator.boolean();
    downloadXlsx = faker.randomGenerator.boolean();

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

  test('should behave correctly on success when is not executing', () async {
    final response = await sut.executeOrDownloadSchedule(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      reportScheduleCode: reportScheduleCode,
      execute: false,
      sendEmailOnExecution: false,
      downloadPdf: downloadPdf,
      downloadXlsx: downloadXlsx,
    );

    expect(
      response,
      reportScheduleExecutionsModels.map((e) => e.toEntity()).toList(),
    );

    verify(
      () => mockDatasource.executeOrDownloadSchedule(
        urlInUse: urlInUse,
        crossIdentity: crossIdentity,
        reportScheduleCode: reportScheduleCode,
        execute: false,
        sendEmailOnExecution: false,
        downloadParams: DownloadParams(
          DownloadLastExecution: downloadPdf || downloadXlsx,
          DownloadPdf: downloadPdf,
          DownloadXlsx: downloadXlsx,
        ),
      ),
    ).called(1);
  });
  test('should behave correctly on success when is executing', () async {
    final sendEmailOnExecution = faker.randomGenerator.boolean();

    final response = await sut.executeOrDownloadSchedule(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      reportScheduleCode: reportScheduleCode,
      execute: true,
      sendEmailOnExecution: sendEmailOnExecution,
      downloadPdf: downloadPdf,
      downloadXlsx: downloadXlsx,
    );

    expect(response, []);

    verify(
      () => mockDatasource.executeOrDownloadSchedule(
        urlInUse: urlInUse,
        crossIdentity: crossIdentity,
        reportScheduleCode: reportScheduleCode,
        execute: true,
        sendEmailOnExecution: sendEmailOnExecution,
        downloadParams: DownloadParams(
          DownloadLastExecution: downloadPdf || downloadXlsx,
          DownloadPdf: downloadPdf,
          DownloadXlsx: downloadXlsx,
        ),
      ),
    ).called(1);
  });
}
