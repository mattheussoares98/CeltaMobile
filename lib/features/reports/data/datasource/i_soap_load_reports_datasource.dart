import '../models/models.dart';

abstract class ISoapLoadReportsDatasource {
  Future<List<ReportScheduleModel>> load({
    required String baseUrl,
    required String crossIdentity,
  });
}
