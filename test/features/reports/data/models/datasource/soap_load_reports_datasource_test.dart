import 'dart:convert';

import 'package:celta_inventario/features/reports/data/datasource/datasource.dart';
import 'package:celta_inventario/features/reports/data/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';

void main() {
  late ISoapLoadReportsDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late List<ReportScheduleModel> reportsModels;

  void initSut() {
    sut = SoapLoadReportsDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {
    soapAdapter.mockPost(
      json.encode(reportsModels.map((e) => e.toJson()).toList()),
    );
  }

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    reportsModels = [
      EntityFactory.makeReportScheduleEntity(),
      EntityFactory.makeReportScheduleEntity(),
      EntityFactory.makeReportScheduleEntity(),
    ].map((e) => ReportScheduleModel.fromEntity(e)).toList();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly in success', () async {
    final response = await sut.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );

    expect(response, reportsModels);

    verify(
      () => soapAdapter.post(
        url: workingUrl,
        typeOfResponse: "GetReportSchedulesJsonResponse",
        soapAction: "GetReportSchedulesJson",
        serviceASMX: "CeltaReportService.asmx",
        typeOfResult: "GetReportSchedulesJsonResult",
        parameters: {
          "json": json.encode({"CrossIdentity": crossIdentity}),
        },
      ),
    ).called(1);
  });
}
