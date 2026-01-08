import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/enterprise/enterprise.dart';
import '../../domain/repositories/enterprise/enterprise.dart';
import '../soap/soap.dart';
import '../supabase/supabase.dart';

part 'enterprise.g.dart';

@riverpod
ISoapEnterpriseDatasource soapEnterpriseDatasource(Ref ref) {
  final soapAdapter = ref.watch(soapRequestProvider);
  return SoapEnterpriseDatasource(soapAdapter: soapAdapter);
}

@riverpod
ISoapUrlValidationDatasource soapUrlValidationDatasource(Ref ref) {
  final soapAdapter = ref.watch(soapRequestProvider);
  return SoapUrlValidationDatasource(soapAdapter);
}

@riverpod
ISupabaseEnterpriseDatasource supabaseEnterpriseDatasource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseEnterpriseDatasource(supabase);
}

@riverpod
ISoapUrlValidationRepository soapUrlValidationRepository(Ref ref) {
  final datasource = ref.watch(soapUrlValidationDatasourceProvider);
  return SoapUrlValidationRepositoryImpl(datasource);
}

@riverpod
IEnterpriseRepository enterpriseRepository(Ref ref) {
  final supabaseEnterpriseDatasource = ref.watch(
    supabaseEnterpriseDatasourceProvider,
  );
  final soapEnterpriseDatasource = ref.watch(soapEnterpriseDatasourceProvider);

  return EnterpriseRepositoryImpl(
    supabaseEnterpriseDatasource: supabaseEnterpriseDatasource,
    soapEnterpriseDatasource: soapEnterpriseDatasource,
  );
}
