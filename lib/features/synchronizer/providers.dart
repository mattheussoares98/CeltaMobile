import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/repositories/repositories.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IEcSynchronizerDatasource ecSynchronizerDatasource(Ref ref) {
  return EcSynchronizerDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcSynchronizerRepository ecSynchronizerRepository(Ref ref) {
  return EcSynchronizerRepositoryImpl(
    ref.watch(ecSynchronizerDatasourceProvider),
  );
}
