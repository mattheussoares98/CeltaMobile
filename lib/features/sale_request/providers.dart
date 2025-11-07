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
