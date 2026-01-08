import '../../../../core/data/datasource/enterprise/enterprise.dart';
import '../../../../core/data/datasource/login/login.dart';
import '../../../../core/data/datasource/user_session/user_session.dart';
import '../../../../core/data/models/models.dart';
import '../../../../core/domain/repositories/enterprise/enterprise.dart';
import '../../../../exceptions/exceptions.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../data/models/models.dart';
import 'i_auth_repository.dart';

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
        ),
      ),
    );
  }
}
