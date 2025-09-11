import 'package:hive/hive.dart';

import '../../../../core/constants/database_keys.dart';
import '../../../../core/domain/entities/user_entity.dart';
import '../models/models.dart';
import 'i_auth_local_datasource.dart';

class AuthLocalDatasource implements IAuthLocalDatasource {
  final Box box;

  AuthLocalDatasource(this.box);

  @override
  Future<void> clearUser() async {
    await box.delete(DatabaseKeys.user.name);
  }

  @override
  Future<UserEntity?> getUser() async {
    final userMap = box.get(DatabaseKeys.user.name);
    if (userMap != null) {
      final userModel = UserModel.fromJson(Map<String, dynamic>.from(userMap));
      return userModel.toEntity();
    }
    return null;
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    await box.put(DatabaseKeys.user.name, UserModel.fromEntity(user).toJson());
  }
}
