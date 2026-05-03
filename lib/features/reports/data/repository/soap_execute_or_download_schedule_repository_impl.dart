import '../datasource/datasource.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/domain/repository/repository.dart';

class SoapExecuteOrDownloadScheduleRepositoryImpl
    implements ISoapExecuteOrDownloadScheduleRepository {
  final ISoapExecuteOrDownloadScheduleDatasource datasource;
  SoapExecuteOrDownloadScheduleRepositoryImpl(this.datasource);

  @override
  Future<List<ScheduleExecutionsEntity>> executeOrDownloadSchedule({
    required String workingUrl,
    required String crossIdentity,
    required int reportScheduleCode,
    required bool execute,
    required bool sendEmailOnExecution,
    required bool downloadPdf,
    required bool downloadXlsx,
  }) async {
    final response = await datasource.executeOrDownloadSchedule(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      reportScheduleCode: reportScheduleCode,
      execute: execute,
      sendEmailOnExecution: sendEmailOnExecution,
      downloadParams: DownloadParams(
        DownloadLastExecution: downloadPdf || downloadXlsx,
        DownloadPdf: downloadPdf,
        DownloadXlsx: downloadXlsx,
      ),
    );

    if (execute) {
      //doesnt return any response
      return [];
    }

    return response.map((e) => e.toEntity()).toList();
  }
}
