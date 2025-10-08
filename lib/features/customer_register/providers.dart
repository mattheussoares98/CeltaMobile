import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/http/http.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

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
