import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/address/address.dart';
import 'package:celta_inventario/core/domain/repositories/address/address.dart';
import 'package:celta_inventario/core/data/repositories/address/address.dart';
import 'package:celta_inventario/core/providers/http/http.dart';

part 'address.g.dart';

@riverpod
ILoadAddressByCepDatasource loadAddressByCepDatasource(Ref ref) {
  return HttpLoadAddressByCepDatasource(ref.watch(httpClientProvider));
}

@riverpod
ILoadAddressByCepRepository loadAddressByCepRepository(Ref ref) {
  return LoadAddressByCepRepositoryImpl(
    ref.watch(loadAddressByCepDatasourceProvider),
  );
}
