import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/address/address.dart';
import '../../domain/repositories/address/address.dart';
import '../http/http.dart';

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
