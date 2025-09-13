import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/data/datasource/datasource.dart';
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
ISoapLoginDataSource soapLoginDataSource(Ref ref) {
  final soapAdapter = ref.watch(soapAdapterProvider);
  return SoapLoginDataSource(soapAdapter);
}

@riverpod
IAuthRepository authRepository(Ref ref) {
  final soapLoginDataSource = ref.watch(soapLoginDataSourceProvider);
  final localDatasource = ref.watch(authLocalDatasourceProvider);
  final enterpriseRepository = ref.watch(enterpriseRepositoryProvider);
  final localUserSessionDataSource = ref.watch(
    localUserSessionDataSourceProvider,
  );

  return AuthRepositoryImpl(
    soapLoginDataSource: soapLoginDataSource,
    authLocalDatasource: localDatasource,
    enterpriseRepository: enterpriseRepository,
    localUserSessionDataSource: localUserSessionDataSource,
  );
}
