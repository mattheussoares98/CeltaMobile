import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/data/datasource/login/login.dart';
import '../../core/providers/providers.dart';
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
  final soapAdapter = ref.watch(soapAdapterProvider);
  return SoapLoginDatasource(soapAdapter);
}

@riverpod
IAuthRepository authRepository(Ref ref) {
  final soapLoginDatasource = ref.watch(soapLoginDatasourceProvider);
  final localDatasource = ref.watch(authLocalDatasourceProvider);
  final enterpriseRepository = ref.watch(enterpriseRepositoryProvider);
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
