import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/features/products_register/domain/repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data/datasource/datasource.dart';
import 'data/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
IEcProductDatasource ecProductDatasource(Ref ref) {
  return EcProductDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcProductRepository ecProductRepository(Ref ref) {
  return EcProductRepositoryImpl(ref.watch(ecProductDatasourceProvider));
}
