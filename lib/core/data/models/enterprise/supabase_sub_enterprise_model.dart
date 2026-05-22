import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class SupabaseSubEnterpriseModel extends Equatable {
  final int? id;
  final int idFromErp;
  final String name;
  final String cnpjNumber;
  final String personalizedCode;
  const SupabaseSubEnterpriseModel({
    required this.id,
    required this.idFromErp,
    required this.name,
    required this.cnpjNumber,
    required this.personalizedCode,
  });

  @override
  List<Object?> get props => [
    id,
    idFromErp,
    name,
    cnpjNumber,
    personalizedCode,
  ];

  factory SupabaseSubEnterpriseModel.fromJson(Map map) {
    return SupabaseSubEnterpriseModel(
      id: map['id'] as int?,
      idFromErp: map['id_from_erp'] as int,
      name: map['name'] as String,
      cnpjNumber: map['cnpj_number'] as String,
      personalizedCode: map['personalized_code'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'id_from_erp': idFromErp,
    'name': name,
    'cnpj_number': cnpjNumber,
    'personalized_code': personalizedCode,
  };

  SubEnterpriseEntity toEntity() => SubEnterpriseEntity(
    id: id,
    idFromErp: idFromErp,
    name: name,
    cnpjNumber: cnpjNumber,
    personalizedCode: personalizedCode,
  );

  factory SupabaseSubEnterpriseModel.fromEntity(SubEnterpriseEntity entity) {
    return SupabaseSubEnterpriseModel(
      id: entity.id,
      idFromErp: entity.idFromErp,
      name: entity.name,
      cnpjNumber: entity.cnpjNumber,
      personalizedCode: entity.personalizedCode,
    );
  }
}
