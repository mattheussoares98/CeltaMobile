import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/data/datasource/login/login.dart';
import '../../core/providers/enterprise/enterprise.dart';
import '../../core/providers/hive/hive.dart';
import '../../core/providers/soap/soap.dart';
import '../../core/providers/user_session/user_session.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
IAuthLocalDatasource authLocalDatasource(Ref ref) {
  final box = ref.watch(hiveBoxProvider);
  return AuthLocalDatasource(box);
}

@riverpod
ISoapLoginDatasource soapLoginDatasource(Ref ref) {
  final soapAdapter = ref.watch(soapRequestProvider);
  return SoapLoginDatasource(soapAdapter);
}

@riverpod
IAuthRepository authRepository(Ref ref) {
  final soapLoginDatasource = ref.watch(soapLoginDatasourceProvider);
  final localDatasource = ref.watch(authLocalDatasourceProvider);
  final enterpriseRepository = ref.watch(supabaseEnterpriseRepositoryProvider);
  final localUserSessionDatasource = ref.watch(
    localUserSessionDatasourceProvider,
  );

  return AuthRepositoryImpl(
    soapLoginDatasource: soapLoginDatasource,
    authLocalDatasource: localDatasource,
    enterpriseRepository: enterpriseRepository,
    localUserSessionDatasource: localUserSessionDatasource,
  );
}
