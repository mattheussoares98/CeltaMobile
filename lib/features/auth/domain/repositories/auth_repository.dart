import '../../../../core/domain/entities/entities.dart';

abstract class AuthRepository {
  Future<void> login({
    required String enterpriseName,
    required String userName,
    required String password,
  });

  Future<UserEntity?> getCurrentUser();

  Future<void> logout();
}
