import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data/datasource/datasource.dart';

part 'providers.g.dart';

@riverpod
IEcProductDatasource ecProductDatasource(Ref ref) {
  return EcProductDatasource(ref.watch(httpClientProvider));
}
