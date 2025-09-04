import '../../domain/entities/entities.dart';

abstract class IAuthLocalDatasource {
  Future<void> saveUser(UserEntity user);
  Future<UserEntity?> getUser();
  Future<void> clearUser();
}
