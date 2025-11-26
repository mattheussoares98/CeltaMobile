import 'dart:convert';

import 'package:celta_intelligence/features/reports/data/models/report_schedule_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadReportsDatasource implements ISoapLoadReportsDatasource {
  final SoapRequest soapRequest;
  SoapLoadReportsDatasource(this.soapRequest);

  @override
  Future<List<ReportScheduleModel>> load({
    required String baseUrl,
    required String crossIdentity,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "GetReportSchedulesJsonResponse",
      soapAction: "GetReportSchedulesJson",
      serviceASMX: "CeltaReportService.asmx",
      typeOfResult: "GetReportSchedulesJsonResult",
      parameters: {
        "json": json.encode({"CrossIdentity": crossIdentity}),
      },
    );

    return (json.decode(response) as List)
        .map((e) => ReportScheduleModel.fromJson(e))
        .toList();
  }
}
