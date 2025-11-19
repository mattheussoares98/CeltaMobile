import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/address/address.dart';
import '../http/http.dart';

part 'load_address_by_cep_datasource_provider.g.dart';

@riverpod
ILoadAddressByCepDatasource loadAddressByCepDatasource(Ref ref) {
  return HttpLoadAddressByCepDatasource(ref.watch(httpClientProvider));
}
