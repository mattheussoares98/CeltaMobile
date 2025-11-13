import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/hive/hive.dart';
import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repository/repository.dart';

part 'providers.g.dart';

@riverpod
ILocalPendingSaleRequestDatasource localPendingSaleRequestDatasource(Ref ref) {
  return LocalPendingSaleRequestDatasource(
    ref.watch(hiveBoxSaleRequestProvider),
  );
}

@riverpod
ILocalPendingSaleRequestRepository localPendingSaleRequestRepository(Ref ref) {
  return LocalPendingSaleRequestRepositoryImpl(
    ref.watch(localPendingSaleRequestDatasourceProvider),
  );
}

@riverpod
ISoapProcessCartDatasource soapProcessCartDatasource(Ref ref) {
  return SoapProcessCartDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapProcessCartRepository soapProcessCartRepository(Ref ref) {
  return SoapProcessCartRepositoryImpl(
    ref.watch(soapProcessCartDatasourceProvider),
  );
}

@riverpod
ISoapSaveSaleRequestDatasource soapSaveSaleRequestDatasource(Ref ref) {
  return SoapSaveSaleRequestDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapSaveSaleRequestRepository soapSaveSaleRequestRepository(Ref ref) {
  return SoapSaveSaleRequestRepositoryImpl(
    ref.watch(soapSaveSaleRequestDatasourceProvider),
  );
}

@riverpod
ILocalLastSavedSaleRequestDatasource localLastSavedSaleRequestDatasource(
  Ref ref,
) {
  return LocalLastSavedSaleRequestDatasource(
    ref.watch(hiveBoxSaleRequestProvider),
  );
}

@riverpod
ILocalLastSavedSaleRequestRepository localLastSavedSaleRequestRepository(
  Ref ref,
) {
  return LocalLastSavedSaleRequestRepositoryImpl(
    ref.watch(localLastSavedSaleRequestDatasourceProvider),
  );
}

@riverpod
IPrintLastSavedSaleRequestDatasource printLastSavedSaleRequestDatasource(
  Ref ref,
) {
  return PrintLastSavedSaleRequestDatasource();
}

@riverpod
IPrintLastSavedSaleRequestRepository printLastSavedSaleRequestRepository(
  Ref ref,
) {
  return PrintLastSavedSaleRequestRepositoryImpl(
    ref.watch(printLastSavedSaleRequestDatasourceProvider),
  );
}

@riverpod
ILocalIpPrintSaleRequestDatasource localIpPrintSaleRequestDatasource(Ref ref) {
  return LocalIpPrintSaleRequestDatasource(
    ref.watch(hiveBoxSaleRequestProvider),
  );
}

@riverpod
ILocalIpPrintSaleRequestRepository localIpPrintSaleRequestRepository(Ref ref) {
  return LocalIpPrintSaleRequestRepositoryImpl(
    ref.watch(localIpPrintSaleRequestDatasourceProvider),
  );
}
