import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/providers.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
IEnterpriseManagerDataSource enterpriseDataSource(Ref ref) {
  return EnterpriseManagerDataSource(ref.watch(supabaseClientProvider));
}

@riverpod
IEnterpriseManagerRepository enterpriseRepository(Ref ref) {
  final datasource = ref.watch(enterpriseDataSourceProvider);
  return EnterpriseManagerRepositoryImpl(datasource);
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
