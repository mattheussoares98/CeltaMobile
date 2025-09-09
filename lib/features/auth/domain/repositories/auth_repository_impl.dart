import '../../../../exceptions/exceptions.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../core/data/datasource/datasource.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../data/datasource/datasource.dart';
import 'i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final ISoapLoginDataSource authRemoteDatasource;
  final IAuthLocalDatasource authLocalDatasource;
  final ISupabaseEnterpriseDatasource
  supabaseEnterpriseDatasource; //TODO create IEnterpriseRepository and ErpEnterpriseDataSource to replace here by this new repository

  AuthRepositoryImpl({
    required this.authRemoteDatasource,
    required this.authLocalDatasource,
    required this.supabaseEnterpriseDatasource,
  });

  @override
  Future<void> login({
    required String enterpriseName,
    required String userName,
    required String password,
  }) async {
    final enterpriseModel = await supabaseEnterpriseDatasource
        .getEnterpriseByName(enterpriseName);
    if (enterpriseModel == null) {
      throw AppException('Empresa não encontrada'.hardcoded);
    }

    final userModel = await authRemoteDatasource.login(
      url: enterpriseModel.baseUrl!,
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
