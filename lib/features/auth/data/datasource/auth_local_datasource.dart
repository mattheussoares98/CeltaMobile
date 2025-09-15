import 'package:hive/hive.dart';

import '../../../../core/constants/database_keys.dart';
import '../../../../core/domain/entities/user_entity.dart';
import '../models/models.dart';
import 'i_auth_local_datasource.dart';

class AuthLocalDatasource implements IAuthLocalDatasource {
  final Box box;

  AuthLocalDatasource(this.box);

  @override
  Future<void> logout() async {
    final localUser = await box.get(DatabaseKeys.user.name);
    await box.delete(DatabaseKeys.user.name);

    if (localUser != null) {
      final user = UserModel.fromJson(Map<String, dynamic>.from(localUser));
      await box.put(
        DatabaseKeys.user.name,
        UserModel(
          name: user.name,
          enterpriseName: user.enterpriseName,
          AccessKey: null,
          CrossIdentity_Usuario: null,
        ).toJson(),
      );
    }
  }

  @override
  Future<UserEntity?> getUser() async {
    final userMap = await box.get(DatabaseKeys.user.name);
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
