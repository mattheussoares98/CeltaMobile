import 'package:celta_inventario/core/providers/hive/hive.dart';
import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/core/providers/soap/soap.dart';
import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/data/repository/repository.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IEcBuyRequestDatasource ecBuyRequestDatasource(Ref ref) {
  return EcBuyRequestDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcBuyRequestRepository ecBuyRequestRepository(Ref ref) {
  return EcBuyRequestRepositoryImpl(ref.watch(ecBuyRequestDatasourceProvider));
}

@riverpod
ISoapLoadEnterpriseByFiltersDatasource soapLoadEnterpriseByFiltersDatasource(
  Ref ref,
) {
  return SoapLoadEnterpriseByFiltersDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadEnterpriseByFiltersRepository soapLoadEnterpriseByFiltersRepository(
  Ref ref,
) {
  return SoapLoadEnterpriseByFiltersRepositoryImpl(
    ref.watch(soapLoadEnterpriseByFiltersDatasourceProvider),
  );
}

@riverpod
ILocalPendingBuyRequestDatasource localPendingBuyRequestDatasource(Ref ref) {
  return LocalPendingBuyRequestDatasource(ref.watch(hiveBoxBuyRequestProvider));
}

@riverpod
ILocalPendingBuyRequestRepository LocalPendingBuyRequestRepository(Ref ref) {
  return LocalPendingBuyRequestRepositoryImpl(
    ref.watch(localPendingBuyRequestDatasourceProvider),
  );
}

@riverpod
ISoapInsertBuyRequestDatasource soapInsertBuyRequestDatasource(Ref ref) {
  return SoapInsertBuyRequestDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapInsertBuyRequestRepository SoapInsertBuyRequestRepository(Ref ref) {
  return SoapInsertBuyRequestRepositoryImpl(
    ref.watch(soapInsertBuyRequestDatasourceProvider),
  );
}
