import 'dart:convert';

import 'package:celta_intelligence/features/reports/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/reports/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapExecuteOrDownloadScheduleDatasource sut;

  late SoapRequestSpy soapRequest;

  late String baseUrl;
  late String crossIdentity;
  late int reportScheduleCode;
  late bool execute;
  late bool sendEmailOnExecution;
  late DownloadParams downloadParams;

  late List<ReportScheduleExecutionsModel> reportScheduleExecutionsModels;

  void initSut() {
    sut = SoapExecuteOrDownloadScheduleDatasource(soapRequest);
  }

  void initInjections() {
    soapRequest = SoapRequestSpy();
  }

  void mockSuccess() {
    soapRequest.mockPost(
      json.encode(
        reportScheduleExecutionsModels.map((e) => e.toJson()).toList(),
      ),
    );
  }

  void initEntities() {
    baseUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    reportScheduleCode = faker.randomGenerator.integer(100);
    execute = faker.randomGenerator.boolean();
    sendEmailOnExecution = faker.randomGenerator.boolean();
    downloadParams = DownloadParams(
      DownloadLastExecution: faker.randomGenerator.boolean(),
      DownloadPdf: faker.randomGenerator.boolean(),
      DownloadXlsx: faker.randomGenerator.boolean(),
    );
    reportScheduleExecutionsModels = [
      EntityFactory.makeReportScheduleExecutionsEntity(),
      EntityFactory.makeReportScheduleExecutionsEntity(),
      EntityFactory.makeReportScheduleExecutionsEntity(),
    ].map((e) => ReportScheduleExecutionsModel.fromEntity(e)).toList();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly in success', () async {
    final response = await sut.executeOrDownloadSchedule(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      reportScheduleCode: reportScheduleCode,
      execute: execute,
      sendEmailOnExecution: sendEmailOnExecution,
      downloadParams: downloadParams,
    );

    expect(response, reportScheduleExecutionsModels);

    verify(
      () => soapRequest.post(
        url: baseUrl,
        typeOfResponse: "GetReportScheduleExecutionsResponse",
        soapAction: "GetReportScheduleExecutions",
        serviceASMX: "CeltaReportService.asmx",
        typeOfResult: "GetReportScheduleExecutionsResult",
        parameters: {
          "json": json.encode({
            "CrossIdentity": crossIdentity,
            "ReportScheduleCode": [reportScheduleCode],
            "Execute": execute,
            "SendEmailOnExecution": sendEmailOnExecution,
            "Download": {
              "DownloadLastExecution": downloadParams.DownloadLastExecution,
              "Pdf": downloadParams.DownloadPdf,
              "Xlsx": downloadParams.DownloadXlsx,
            },
          }),
        },
      ),
    ).called(1);
  });
}
