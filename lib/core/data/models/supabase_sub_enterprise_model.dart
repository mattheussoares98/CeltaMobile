import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class SupabaseSubEnterpriseModel extends Equatable {
  final int? id;
  final String name;
  final String cnpjNumber;
  final String personalizedCode;
  const SupabaseSubEnterpriseModel({
    required this.id,
    required this.name,
    required this.cnpjNumber,
    required this.personalizedCode,
  });

  @override
  List<Object?> get props => [id, name, cnpjNumber, personalizedCode];

  factory SupabaseSubEnterpriseModel.fromJson(Map<String, dynamic> map) {
    return SupabaseSubEnterpriseModel(
      id: map['id'] as int,
      name: map['name'] as String,
      cnpjNumber: map['cnpj_number'] as String,
      personalizedCode: map['personalized_code'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'cnpj_number': cnpjNumber,
    'personalized_code': personalizedCode,
  };

  SubEnterpriseEntity toEntity() => SubEnterpriseEntity(
    id: id,
    name: name,
    cnpjNumber: cnpjNumber,
    personalizedCode: personalizedCode,
  );

  factory SupabaseSubEnterpriseModel.fromEntity(SubEnterpriseEntity entity) {
    return SupabaseSubEnterpriseModel(
      id: entity.id,
      name: entity.name,
      cnpjNumber: entity.cnpjNumber,
      personalizedCode: entity.personalizedCode,
    );
  }
}
