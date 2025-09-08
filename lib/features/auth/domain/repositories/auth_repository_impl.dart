import '../../../../exceptions/exceptions.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../core/data/data_source/data_source.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../data/data_source/data_source.dart';
import 'i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDatasource authRemoteDatasource;
  final IAuthLocalDatasource authLocalDatasource;
  final IEnterpriseDatasource enterpriseDatasource;

  AuthRepositoryImpl({
    required this.authRemoteDatasource,
    required this.authLocalDatasource,
    required this.enterpriseDatasource,
  });

  @override
  Future<void> login({
    required String enterpriseName,
    required String userName,
    required String password,
  }) async {
    final enterpriseModel = await enterpriseDatasource.getEnterprise(
      enterpriseName,
    );
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
