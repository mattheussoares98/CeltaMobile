import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/address/address.dart';
import 'address.dart';

part 'load_address_by_cep_repository_provider.g.dart';

@riverpod
ILoadAddressByCepRepository loadAddressByCepRepository(Ref ref) {
  return LoadAddressByCepRepositoryImpl(
    ref.watch(loadAddressByCepDatasourceProvider),
  );
}
