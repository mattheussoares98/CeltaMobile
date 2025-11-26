import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repository.dart';

class SoapExecuteOrDownloadScheduleRepositoryImpl
    implements ISoapExecuteOrDownloadScheduleRepository {
  final ISoapExecuteOrDownloadScheduleDatasource datasource;
  SoapExecuteOrDownloadScheduleRepositoryImpl(this.datasource);

  @override
  Future<List<ReportScheduleExecutionsEntity>> executeOrDownloadSchedule({
    required String baseUrl,
    required String crossIdentity,
    required int reportScheduleCode,
    required bool execute,
    required bool sendEmailOnExecution,
    required DownloadParams downloadParams,
  }) async {
    final response = await datasource.executeOrDownloadSchedule(
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
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
