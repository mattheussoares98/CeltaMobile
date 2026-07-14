import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IEcSynchronizerDatasource ecSynchronizerDatasource(Ref ref) {
  return EcSynchronizerDatasource(ref.watch(httpClientProvider));
}
