import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/features/process_authorization/data/datasource/datasource.dart';
import 'package:celta_inventario/features/process_authorization/data/repositories/repositorires.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IEcProcessAuthorizationDatasource ecProcessAuthorizationDatasource(Ref ref) {
  return EcProcessAuthorizationDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcProcessAuthorizationRepository ecProcessAuthorizationRepository(Ref ref) {
  return EcProcessAuthorizationRepositoryImpl(
    ref.watch(ecProcessAuthorizationDatasourceProvider),
  );
}
