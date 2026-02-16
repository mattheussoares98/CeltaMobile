import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/enterprise/enterprise.dart';
import '../../core/providers/supabase/supabase.dart';
import '../auth/providers.dart';
import 'data/datasource/datasource.dart';
import 'domain/entities/entities.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
IEnterpriseManagerDatasource enterpriseManagerDatasource(Ref ref) {
  return EnterpriseManagerDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
IEnterpriseManagerRepository enterpriseManagerRepository(Ref ref) {
  final enterpriseManagerDatasource = ref.watch(
    enterpriseManagerDatasourceProvider,
  );
  final soapLoginDatasource = ref.watch(soapLoginDatasourceProvider);
  final soapEnterpriseDatasource = ref.watch(soapEnterpriseDatasourceProvider);
  final soapUrlValidationDatasource = ref.read(
    soapUrlValidationDatasourceProvider,
  );

  return EnterpriseManagerRepositoryImpl(
    enterpriseManagerDatasource: enterpriseManagerDatasource,
    soapLoginDatasource: soapLoginDatasource,
    soapEnterpriseDatasource: soapEnterpriseDatasource,
    soapUrlValidationDatasource: soapUrlValidationDatasource,
  );
}

@riverpod
IAuthManagerDatasource authManagerDatasource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthManagerDatasource(supabase);
}

@riverpod
IAuthManagerRepository authManagerRepository(Ref ref) {
  final datasource = ref.watch(authManagerDatasourceProvider);
  return AuthManagerRepositoryImpl(datasource);
}

@riverpod
Future<EnterprisePermissionEntity?> enterprisePermissions(
  Ref ref,
  int enterpriseId,
) async {
  final repository = ref.watch(enterpriseManagerRepositoryProvider);

  return await repository.getEnterprisePermissionsById(enterpriseId);
}
