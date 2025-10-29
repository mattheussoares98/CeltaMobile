import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/hive/hive.dart';
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
