import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repository/repository.dart';
import 'data/repository/repository.dart';

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
