import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/data/datasource/login/login.dart';
import '../../core/providers/enterprise/enterprise.dart';
import '../../core/providers/soap/soap.dart';
import '../../core/providers/user_session/user_session.dart';
import 'domain/repositories/repositories.dart';
import 'data/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
ISoapLoginDatasource soapLoginDatasource(Ref ref) {
  final soapAdapter = ref.watch(soapRequestProvider);
  return SoapLoginDatasource(soapAdapter);
}

@riverpod
IAuthRepository authRepository(Ref ref) {
  final soapLoginDatasource = ref.watch(soapLoginDatasourceProvider);
  final enterpriseRepository = ref.watch(enterpriseRepositoryProvider);
  final localUserSessionDatasource = ref.watch(userSessionDatasourceProvider);
  final soapUrlValidationDatasource = ref.read(
    soapUrlValidationDatasourceProvider,
  );

  return AuthRepositoryImpl(
    soapLoginDatasource: soapLoginDatasource,
    enterpriseRepository: enterpriseRepository,
    localUserSessionDatasource: localUserSessionDatasource,
    soapUrlValidationDatasource: soapUrlValidationDatasource,
  );
}
