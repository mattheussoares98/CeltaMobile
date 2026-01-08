import '../entities/entities.dart';

abstract class ISoapExecuteOrDownloadScheduleRepository {
  Future<List<ScheduleExecutionsEntity>> executeOrDownloadSchedule({
    required String urlInUse,
    required String crossIdentity,
    required int reportScheduleCode,
    required bool execute,
    required bool sendEmailOnExecution,
    required bool downloadPdf,
    required bool downloadXlsx,
  });
}
