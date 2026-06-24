import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/features/process_authorization/data/datasource/datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IEcProcessAuthorizationDatasource ecProcessAuthorizationDatasource(Ref ref) {
  return EcProcessAuthorizationDatasource(ref.watch(httpClientProvider));
}
