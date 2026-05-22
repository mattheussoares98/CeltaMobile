import 'package:celta_inventario/features/auth/domain/repositories/repositories.dart';

import 'package:celta_inventario/core/data/datasource/enterprise/enterprise.dart';
import 'package:celta_inventario/core/data/datasource/login/login.dart';
import 'package:celta_inventario/core/data/datasource/user_session/user_session.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/repositories/enterprise/enterprise.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/auth/data/models/models.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final ISoapLoginDatasource soapLoginDatasource;
  final IEnterpriseRepository enterpriseRepository;
  final ILocalUserSessionDatasource localUserSessionDatasource;
  final ISoapUrlValidationDatasource soapUrlValidationDatasource;

  AuthRepositoryImpl({
    required this.soapLoginDatasource,
    required this.enterpriseRepository,
    required this.localUserSessionDatasource,
    required this.soapUrlValidationDatasource,
  });

  @override
  Future<void> login({
    required String enterpriseName,
    required String userName,
    required String password,
  }) async {
    final enterprise = await enterpriseRepository.getSupabaseEnterpriseByName(
      enterpriseName,
    );
    if (enterprise == null) {
      throw AppException('Empresa não encontrada'.hardcoded);
    }

    final urlWorking = await soapUrlValidationDatasource.findWorkingUrl([
      enterprise.remoteHttpUrl!,
      ?enterprise.remoteHttpsUrl,
      ?enterprise.localHttpUrl,
      ?enterprise.localHttpsUrl,
    ]);

    final remoteUser = await soapLoginDatasource.login(
      workingUrl: urlWorking,
      user: userName,
      password: password,
    );

    await localUserSessionDatasource.save(
      UserSessionModel(
        enterprise: SupabaseEnterpriseModel.fromEntity(enterprise),
        user: UserModel(
          name: userName,
          enterpriseName: enterpriseName,
          AccessKey: remoteUser.AccessKey,
          CrossIdentity_Usuario: remoteUser.CrossIdentity_Usuario,
          CodigoInterno_Usuario: remoteUser.CodigoInterno_Usuario,
        ),
      ),
    );
  }
}
