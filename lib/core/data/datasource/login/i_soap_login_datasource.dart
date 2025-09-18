import '../../../../features/auth/data/models/models.dart'; // Make sure to create a UserModel

abstract class ISoapLoginDatasource {
  /// Calls the ERP login endpoint and returns the raw user data as a UserModel.
  Future<UserModel> login({
    required String baseUrl,
    required String user,
    required String password,
  });
}
