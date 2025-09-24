import '../../../../core/data/datasource/login/login.dart';
import '../../../../core/data/datasource/user_session/user_session.dart';
import '../../../../core/data/models/models.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/domain/repositories/enterprise/enterprise.dart';
import '../../../../exceptions/exceptions.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../data/datasource/datasource.dart';
import 'i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final ISoapLoginDatasource soapLoginDatasource;
  final IAuthLocalDatasource authLocalDatasource;
  final IEnterpriseRepository enterpriseRepository;
  final ILocalUserSessionDatasource localUserSessionDatasource;

  AuthRepositoryImpl({
    required this.soapLoginDatasource,
    required this.authLocalDatasource,
    required this.enterpriseRepository,
    required this.localUserSessionDatasource,
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

    final remoteUser = await soapLoginDatasource.login(
      baseUrl: enterprise.baseUrl!,
      user: userName,
      password: password,
    );

    await authLocalDatasource.saveUser(
      UserEntity(
        name: userName,
        enterpriseName: enterpriseName,
        AccessKey: remoteUser.AccessKey,
        CrossIdentity_Usuario: remoteUser.CrossIdentity_Usuario,
      ),
    );

    await localUserSessionDatasource.save(
      UserSessionModel(
        enterprise: SupabaseEnterpriseModel.fromEntity(enterprise),
        user: remoteUser,
      ),
    );
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await authLocalDatasource.getUser();
  }

  @override
  Future<void> logout() async {
    await authLocalDatasource.logout();
  }
}
