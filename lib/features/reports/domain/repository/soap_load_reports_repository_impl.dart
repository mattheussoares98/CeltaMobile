import 'package:celta_intelligence/features/reports/domain/entities/report_schedule_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repository.dart';

class SoapLoadReportsRepositoryImpl implements ISoapLoadReportsRepository {
  final ISoapLoadReportsDatasource datasource;
  SoapLoadReportsRepositoryImpl(this.datasource);

  @override
  Future<List<ReportScheduleEntity>> load({
    required String urlInUse,
    required String crossIdentity,
  }) async {
    final response = await datasource.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
