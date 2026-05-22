import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/soap/soap.dart';
import 'package:celta_inventario/features/reports/data/datasource/datasource.dart';
import 'package:celta_inventario/features/reports/domain/repository/repository.dart';
import 'package:celta_inventario/features/reports/data/repository/repository.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadReportsDatasource soapLoadReportsDatasource(Ref ref) {
  return SoapLoadReportsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadReportsRepository soapLoadReportsRepository(Ref ref) {
  return SoapLoadReportsRepositoryImpl(
    ref.watch(soapLoadReportsDatasourceProvider),
  );
}

@riverpod
ISoapExecuteOrDownloadScheduleDatasource
soapExecuteOrDownloadScheduleDatasource(Ref ref) {
  return SoapExecuteOrDownloadScheduleDatasource(
    ref.watch(soapRequestProvider),
  );
}

@riverpod
ISoapExecuteOrDownloadScheduleRepository
soapExecuteOrDownloadScheduleRepository(Ref ref) {
  return SoapExecuteOrDownloadScheduleRepositoryImpl(
    ref.watch(soapExecuteOrDownloadScheduleDatasourceProvider),
  );
}
