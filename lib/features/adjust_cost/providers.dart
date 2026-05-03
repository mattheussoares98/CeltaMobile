import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/http/http.dart';
import 'data/datasource/datasource.dart';
import 'domain/repository/repository.dart';
import 'data/repository/repository.dart';

part 'providers.g.dart';

@riverpod
IEcAdjustCostDatasource ecAdjustCostDatasource(Ref ref) {
  return EcAdjustCostDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcAdjustCostRepository ecAdjustCostRepository(Ref ref) {
  return EcAdjustCostRepositoryImpl(ref.watch(ecAdjustCostDatasourceProvider));
}
