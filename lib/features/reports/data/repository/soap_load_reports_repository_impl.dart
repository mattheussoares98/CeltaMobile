import 'package:celta_inventario/features/reports/domain/entities/report_schedule_entity.dart';

import '../datasource/datasource.dart';
import 'package:celta_inventario/features/reports/domain/repository/repository.dart';

class SoapLoadReportsRepositoryImpl implements ISoapLoadReportsRepository {
  final ISoapLoadReportsDatasource datasource;
  SoapLoadReportsRepositoryImpl(this.datasource);

  @override
  Future<List<ReportScheduleEntity>> load({
    required String workingUrl,
    required String crossIdentity,
  }) async {
    final response = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
