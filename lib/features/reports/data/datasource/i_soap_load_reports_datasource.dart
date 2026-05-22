import 'package:celta_inventario/features/reports/data/models/models.dart';

abstract class ISoapLoadReportsDatasource {
  Future<List<ReportScheduleModel>> load({
    required String workingUrl,
    required String crossIdentity,
  });
}
