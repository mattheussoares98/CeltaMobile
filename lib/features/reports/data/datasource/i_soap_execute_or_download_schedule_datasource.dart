import 'package:equatable/equatable.dart';

import '../models/models.dart';

abstract class ISoapExecuteOrDownloadScheduleDatasource {
  Future<List<ScheduleExecutionsModel>> executeOrDownloadSchedule({
    required String urlInUse,
    required String crossIdentity,
    required int reportScheduleCode,
    required bool execute,
    required bool sendEmailOnExecution,
    required DownloadParams downloadParams,
  });
}

class DownloadParams extends Equatable {
  final bool DownloadLastExecution;
  final bool DownloadPdf;
  final bool DownloadXlsx;

  const DownloadParams({
    required this.DownloadLastExecution,
    required this.DownloadPdf,
    required this.DownloadXlsx,
  });

  @override
  List<Object?> get props => [DownloadLastExecution, DownloadPdf, DownloadXlsx];
}
