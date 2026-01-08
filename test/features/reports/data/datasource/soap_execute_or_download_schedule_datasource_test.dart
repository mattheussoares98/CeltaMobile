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

  late String urlInUse;
  late String crossIdentity;
  late int reportScheduleCode;
  late DownloadParams downloadParams;

  late List<ScheduleExecutionsModel> reportScheduleExecutionsModels;

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
    urlInUse = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    reportScheduleCode = faker.randomGenerator.integer(100);
    downloadParams = DownloadParams(
      DownloadLastExecution: faker.randomGenerator.boolean(),
      DownloadPdf: faker.randomGenerator.boolean(),
      DownloadXlsx: faker.randomGenerator.boolean(),
    );
    reportScheduleExecutionsModels = [
      EntityFactory.makeScheduleExecutionsEntity(),
      EntityFactory.makeScheduleExecutionsEntity(),
      EntityFactory.makeScheduleExecutionsEntity(),
    ].map((e) => ScheduleExecutionsModel.fromEntity(e)).toList();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly in success and is not executing', () async {
    final response = await sut.executeOrDownloadSchedule(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      reportScheduleCode: reportScheduleCode,
      execute: false,
      sendEmailOnExecution: false,
      downloadParams: downloadParams,
    );

    expect(response, reportScheduleExecutionsModels);

    verify(
      () => soapRequest.post(
        url: urlInUse,
        typeOfResponse: "GetReportScheduleExecutionsResponse",
        soapAction: "GetReportScheduleExecutions",
        serviceASMX: "CeltaReportService.asmx",
        typeOfResult: "GetReportScheduleExecutionsResult",
        parameters: {
          "json": json.encode({
            "CrossIdentity": crossIdentity,
            "ReportScheduleCode": [reportScheduleCode],
            "Execute": false,
            "SendEmailOnExecution": false,
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
  test('should behave correctly in success and is executing', () async {
    final sendEmailOnExecution = faker.randomGenerator.boolean();
    final response = await sut.executeOrDownloadSchedule(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      reportScheduleCode: reportScheduleCode,
      execute: true,
      sendEmailOnExecution: sendEmailOnExecution,
      downloadParams: downloadParams,
    );

    expect(response, []);

    verify(
      () => soapRequest.post(
        url: urlInUse,
        typeOfResponse: "GetReportScheduleExecutionsResponse",
        soapAction: "GetReportScheduleExecutions",
        serviceASMX: "CeltaReportService.asmx",
        typeOfResult: "GetReportScheduleExecutionsResult",
        parameters: {
          "json": json.encode({
            "CrossIdentity": crossIdentity,
            "ReportScheduleCode": [reportScheduleCode],
            "Execute": true,
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
