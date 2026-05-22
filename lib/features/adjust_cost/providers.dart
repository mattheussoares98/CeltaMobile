import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/features/adjust_cost/data/datasource/datasource.dart';
import 'package:celta_inventario/features/adjust_cost/domain/repository/repository.dart';
import 'package:celta_inventario/features/adjust_cost/data/repository/repository.dart';

part 'providers.g.dart';

@riverpod
IEcAdjustCostDatasource ecAdjustCostDatasource(Ref ref) {
  return EcAdjustCostDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcAdjustCostRepository ecAdjustCostRepository(Ref ref) {
  return EcAdjustCostRepositoryImpl(ref.watch(ecAdjustCostDatasourceProvider));
}
