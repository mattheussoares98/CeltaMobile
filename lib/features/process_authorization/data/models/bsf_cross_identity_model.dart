// lib/features/process_authorization/data/models/bsf_cross_identity_model.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFCrossIdentityModel extends BSFCrossIdentityEntity {
  const BSFCrossIdentityModel({
    super.identification,
    super.password,
  });

  factory BSFCrossIdentityModel.fromJson(Map json) => BSFCrossIdentityModel(
        identification: json['Identification']?.toString(),
        password: json['Password']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'Identification': identification,
        'Password': password,
      };

  factory BSFCrossIdentityModel.fromEntity(BSFCrossIdentityEntity entity) =>
      BSFCrossIdentityModel(
        identification: entity.identification,
        password: entity.password,
      );

  BSFCrossIdentityEntity toEntity() => BSFCrossIdentityEntity(
        identification: identification,
        password: password,
      );
}
