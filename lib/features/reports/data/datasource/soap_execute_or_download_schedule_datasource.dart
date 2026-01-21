import 'dart:convert';

import 'package:celta_inventario/features/reports/data/models/schedule_executions_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapExecuteOrDownloadScheduleDatasource
    implements ISoapExecuteOrDownloadScheduleDatasource {
  final SoapRequest soapRequest;
  SoapExecuteOrDownloadScheduleDatasource(this.soapRequest);

  @override
  Future<List<ScheduleExecutionsModel>> executeOrDownloadSchedule({
    required String workingUrl,
    required String crossIdentity,
    required int reportScheduleCode,
    required bool execute,
    required bool sendEmailOnExecution,
    required DownloadParams downloadParams,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
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
    );

    if (execute) {
      return [];
    }

    return (json.decode(response) as List)
        .map((e) => ScheduleExecutionsModel.fromJson(e))
        .toList();
  }
}
