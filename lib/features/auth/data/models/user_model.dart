import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class UserModel extends Equatable {
  final String? name;
  final String? enterpriseName;
  final String? AccessKey;
  final String? CrossIdentity_Usuario;
  final int? CodigoInterno_Usuario;

  const UserModel({
    required this.name,
    required this.enterpriseName,
    required this.AccessKey,
    required this.CrossIdentity_Usuario,
    required this.CodigoInterno_Usuario,
  });

  @override
  List<Object?> get props => [
    name,
    enterpriseName,
    AccessKey,
    CrossIdentity_Usuario,
    CodigoInterno_Usuario,
  ];

  factory UserModel.fromJson(Map json) {
    return UserModel(
      name: json['name'],
      enterpriseName: json['enterpriseName'],
      AccessKey: json['AccessKey'],
      CrossIdentity_Usuario: json['CrossIdentity_Usuario'],
      CodigoInterno_Usuario: json['CodigoInterno_Usuario'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'enterpriseName': enterpriseName,
    'AccessKey': AccessKey,
    'CrossIdentity_Usuario': CrossIdentity_Usuario,
    'CodigoInterno_Usuario': CodigoInterno_Usuario,
  };

  UserEntity toEntity() {
    return UserEntity(
      name: name,
      enterpriseName: enterpriseName,
      AccessKey: AccessKey,
      CrossIdentity_Usuario: CrossIdentity_Usuario,
      CodigoInterno_Usuario: CodigoInterno_Usuario,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      name: entity.name,
      enterpriseName: entity.enterpriseName,
      AccessKey: entity.AccessKey,
      CrossIdentity_Usuario: entity.CrossIdentity_Usuario,
      CodigoInterno_Usuario: entity.CodigoInterno_Usuario,
    );
  }
}
