import '../../../../core/domain/repositories/repositores.dart';
import '../../../../exceptions/exceptions.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../core/data/datasource/datasource.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../data/datasource/datasource.dart';
import 'i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final ISoapLoginDataSource soapLoginDataSource;
  final IAuthLocalDatasource authLocalDatasource;
  final IEnterpriseRepository enterpriseRepository;

  AuthRepositoryImpl({
    required this.soapLoginDataSource,
    required this.authLocalDatasource,
    required this.enterpriseRepository,
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

    final userModel = await soapLoginDataSource.login(
      baseUrl: enterpriseModel.baseUrl!,
      user: userName,
      password: password,
    );

    await authLocalDatasource.saveUser(userModel.toEntity());
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await authLocalDatasource.getUser();
  }

  @override
  Future<void> logout() async {
    await authLocalDatasource.clearUser();
  }
}
