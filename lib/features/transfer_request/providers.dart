import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/hive/hive.dart';
import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadDestinyEnterprisesDatasource soapLoadDestinyEnterprisesDatasource(
  Ref ref,
) {
  return SoapLoadDestinyEnterprisesDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadDestinyEnterprisesRepository soapLoadDestinyEnterprisesRepository(
  Ref ref,
) {
  return SoapLoadDestinyEnterprisesRepositoryImpl(
    ref.watch(soapLoadDestinyEnterprisesDatasourceProvider),
  );
}

@riverpod
ILocalCartDatasource localCartDatasource(Ref ref) {
  return LocalCartDatasource(ref.watch(hiveBoxTransferRequestProvider));
}

@riverpod
ILocalCartRepository localCartRepository(Ref ref) {
  return LocalCartRepositoryImpl(ref.watch(localCartDatasourceProvider));
}

@riverpod
ILocalLastSavedNumberDatasource localLastSavedNumberDatasource(Ref ref) {
  return LocalLastSavedNumberDatasource(
    ref.watch(hiveBoxTransferRequestProvider),
  );
}

@riverpod
ILocalLastSavedNumberRepository localLastSavedNumberRepository(Ref ref) {
  return LocalLastSavedNumberRepositoryImpl(
    ref.watch(localLastSavedNumberDatasourceProvider),
  );
}

@riverpod
ISoapInsertTransferRequestDatasource soapInsertTransferRequestDatasource(
  Ref ref,
) {
  return SoapInsertTransferRequestDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapInsertTransferRequestRepository soapInsertTransferRequestRepository(
  Ref ref,
) {
  return SoapInsertTransferRequestRepositoryImpl(
    ref.watch(soapInsertTransferRequestDatasourceProvider),
  );
}
