import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

class UserModel extends Equatable {
  final String? name;
  final String? AccessKey;
  final String? CrossIdentity_Usuario;

  const UserModel({
    required this.name,
    required this.AccessKey,
    required this.CrossIdentity_Usuario,
  });

  @override
  List<Object?> get props => [name, AccessKey, CrossIdentity_Usuario];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      AccessKey: json['AccessKey'],
      CrossIdentity_Usuario: json['CrossIdentity_Usuario'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'AccessKey': AccessKey,
    'CrossIdentity_Usuario': CrossIdentity_Usuario,
  };

  UserEntity toEntity() {
    return UserEntity(
      name: name,
      AccessKey: AccessKey,
      CrossIdentity_Usuario: CrossIdentity_Usuario,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      name: entity.name,
      AccessKey: entity.AccessKey,
      CrossIdentity_Usuario: entity.CrossIdentity_Usuario,
    );
  }
}
