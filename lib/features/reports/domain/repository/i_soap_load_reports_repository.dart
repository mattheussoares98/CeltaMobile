import '../entities/entities.dart';

abstract class ISoapLoadReportsRepository {
  Future<List<ReportScheduleEntity>> load({
    required String urlInUse,
    required String crossIdentity,
  });
}
