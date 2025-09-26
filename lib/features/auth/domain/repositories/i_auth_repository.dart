abstract class IAuthRepository {
  Future<void> login({
    required String enterpriseName,
    required String userName,
    required String password,
  });
}
