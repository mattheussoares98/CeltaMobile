import '../../../../core/data/models/models.dart';
import '../../../../core/domain/repositories/repositores.dart';
import '../../../../exceptions/exceptions.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../core/data/datasource/datasource.dart';
import '../../../../core/domain/entities/entities.dart';
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
    final enterpriseModel = await enterpriseRepository
        .getSupabaseEnterpriseByName(enterpriseName);
    if (enterpriseModel == null) {
      throw AppException('Empresa não encontrada'.hardcoded);
    }

    final remoteUser = await soapLoginDatasource.login(
      baseUrl: enterpriseModel.baseUrl!,
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
      UserSessionModel(baseUrl: enterpriseModel.baseUrl),
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
