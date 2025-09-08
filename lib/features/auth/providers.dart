import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/providers.dart';
import 'data/data_source/data_source.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
IAuthLocalDatasource authLocalDatasource(Ref ref) {
  final box = ref.watch(hiveBoxProvider);
  return AuthLocalDatasource(box);
}

@riverpod
IAuthRemoteDatasource authRemoteDatasource(Ref ref) {
  final soapAdapter = ref.watch(soapAdapterProvider);
  return AuthRemoteDatasource(soapAdapter);
}

@riverpod
IAuthRepository authRepository(Ref ref) {
  final remoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final localDatasource = ref.watch(authLocalDatasourceProvider);
  final enterpriseDatasource = ref.watch(supabaseEnterpriseDatasourceProvider);

  return AuthRepositoryImpl(
    authRemoteDatasource: remoteDatasource,
    authLocalDatasource: localDatasource,
    supabaseEnterpriseDatasource: enterpriseDatasource,
  );
}
