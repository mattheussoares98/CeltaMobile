import '../entities/entities.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String enterpriseName,
    required String email,
    required String password,
  });

  Future<bool> verifyIsLogged();

  Future<void> logout();
}
