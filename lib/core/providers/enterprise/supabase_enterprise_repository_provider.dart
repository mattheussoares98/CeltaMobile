import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/enterprise/enterprise.dart';
import 'enterprise.dart';

part 'supabase_enterprise_repository_provider.g.dart';

@riverpod
IEnterpriseRepository supabaseEnterpriseRepository(Ref ref) {
  final supabaseEnterpriseDatasource = ref.watch(
    supabaseEnterpriseDatasourceProvider,
  );
  final soapEnterpriseDatasource = ref.watch(soapEnterpriseDatasourceProvider);

  return EnterpriseRepositoryImpl(
    supabaseEnterpriseDatasource: supabaseEnterpriseDatasource,
    soapEnterpriseDatasource: soapEnterpriseDatasource,
  );
}
