import '../../../../exceptions/exceptions.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../core/data/data_source/data_source.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../data/data_source/data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final IAuthRemoteDatasource _remoteDatasource;
  final IAuthLocalDatasource _localDatasource;
  final IEnterpriseDatasource _enterpriseDatasource;

  AuthRepositoryImpl({
    required IAuthRemoteDatasource remoteDatasource,
    required IAuthLocalDatasource localDatasource,
    required IEnterpriseDatasource enterpriseDatasource,
  }) : _remoteDatasource = remoteDatasource,
       _localDatasource = localDatasource,
       _enterpriseDatasource = enterpriseDatasource;

  @override
  Future<void> login({
    required String enterpriseName,
    required String userName,
    required String password,
  }) async {
    final enterpriseModel = await _enterpriseDatasource.getEnterprise(
      enterpriseName,
    );
    if (enterpriseModel == null) {
      //TODO create tests and verify why is not in a try-catch
      throw AppException('Empresa não encontrada'.hardcoded);
    }

    final userModel = await _remoteDatasource.login(
      url: enterpriseModel.baseUrl!,
      user: userName,
      password: password,
    );

    await _localDatasource.saveUser(userModel.toEntity());
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    //TODO test
    return await _localDatasource.getUser();
  }

  @override
  Future<void> logout() async {
    //TODO test
    await _localDatasource.clearUser();
  }
}
