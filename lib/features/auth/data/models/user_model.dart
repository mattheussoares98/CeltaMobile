import '../../../../core/domain/entities/entities.dart';

class UserModel {
  final String? name;
  final String? AccessKey;
  final String? CrossIdentity_Usuario;

  const UserModel({
    required this.name,
    required this.AccessKey,
    required this.CrossIdentity_Usuario,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      AccessKey: json['AccessKey'],
      CrossIdentity_Usuario: json['CrossIdentity_Usuario'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      name: name,
      AccessKey: AccessKey,
      CrossIdentity_Usuario: CrossIdentity_Usuario,
    );
  }
}
