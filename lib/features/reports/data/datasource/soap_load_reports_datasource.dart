import 'dart:convert';

import 'package:celta_inventario/features/reports/data/models/report_schedule_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadReportsDatasource implements ISoapLoadReportsDatasource {
  final SoapRequest soapRequest;
  SoapLoadReportsDatasource(this.soapRequest);

  @override
  Future<List<ReportScheduleModel>> load({
    required String workingUrl,
    required String crossIdentity,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
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
