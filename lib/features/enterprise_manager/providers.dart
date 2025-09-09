import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/providers.dart';
import '../auth/providers.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
IEnterpriseManagerDataSource enterpriseManagerDataSource(Ref ref) {
  return EnterpriseManagerDataSource(ref.watch(supabaseClientProvider));
}

@riverpod
IEnterpriseManagerRepository enterpriseManagerRepository(Ref ref) {
  final enterpriseManagerDataSource = ref.watch(
    enterpriseManagerDataSourceProvider,
  );
  final soapLoginDataSource = ref.watch(soapLoginDataSourceProvider);
  final soapEnterpriseDataSource = ref.watch(soapEnterpriseDataSourceProvider);

  return EnterpriseManagerRepositoryImpl(
    enterpriseManagerDataSource: enterpriseManagerDataSource,
    soapLoginDataSource: soapLoginDataSource,
    soapEnterpriseDataSource: soapEnterpriseDataSource,
  );
}

@riverpod
IAuthManagerDataSource authManagerDataSource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthManagerDataSource(supabase);
}

@riverpod
IAuthManagerRepository authManagerRepository(Ref ref) {
  final datasource = ref.watch(authManagerDataSourceProvider);
  return AuthManagerRepositoryImpl(datasource);
}
