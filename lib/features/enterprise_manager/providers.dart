import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/providers.dart';
import 'data/data_source/data_source.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
IEnterpriseDataSource enterpriseDataSource(Ref ref) {
  return EnterpriseDataSource(ref.watch(supabaseClientProvider));
}

@riverpod
IEnterpriseRepository enterpriseRepository(Ref ref) {
  final datasource = ref.watch(enterpriseDataSourceProvider);
  return EnterpriseRepositoryImpl(datasource);
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
