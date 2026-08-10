import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IEcCommerceSiteDatasource ecCommerceSiteDatasource(Ref ref) =>
    EcCommerceSiteDatasource(ref.watch(httpClientProvider));

@riverpod
IEcCommerceSiteRepository ecCommerceSiteRepository(Ref ref) =>
    EcCommerceSiteRepositoryImpl(
      EcCommerceSiteDatasource(ref.watch(httpClientProvider)),
    );

@riverpod
IEcSynchronizerDatasource ecSynchronizerDatasource(Ref ref) =>
    EcSynchronizerDatasource(ref.watch(httpClientProvider));

@riverpod
IEcSynchronizerRepository ecSynchronizerRepository(Ref ref) {
  return EcSynchronizerRepositoryImpl(
    ref.watch(ecSynchronizerDatasourceProvider),
  );
}

@riverpod
IEcSynchronizerManualExecutionDatasource
ecSynchronizerManualExecutionDatasource(Ref ref) {
  return EcSynchronizerManualExecutionDatasource(ref.watch(httpClientProvider));
}
