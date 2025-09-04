import '../models/models.dart'; // Make sure to create a UserModel

abstract class IAuthRemoteDatasource {
  /// Calls the ERP login endpoint and returns the raw user data as a UserModel.
  Future<UserModel> login({
    required String url,
    required String user,
    required String password,
  });
}
