import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/hive/hive.dart';
import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repository/repository.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadBuyersDatasource soapLoadBuyersDatasource(Ref ref) {
  return SoapLoadBuyersDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadBuyersRepository soapLoadBuyersRepository(Ref ref) {
  return SoapLoadBuyersRepositoryImpl(
    ref.watch(soapLoadBuyersDatasourceProvider),
  );
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
