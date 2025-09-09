import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class SupabaseSubEnterpriseModel extends Equatable {
  final String? id;
  final String name;
  final String cnpj;
  const SupabaseSubEnterpriseModel({
    required this.id,
    required this.name,
    required this.cnpj,
  });

  @override
  List<Object?> get props => [id, name, cnpj];

  factory SupabaseSubEnterpriseModel.fromJson(Map<String, dynamic> map) {
    return SupabaseSubEnterpriseModel(
      id: map['id'] as String,
      name: map['name'] as String,
      cnpj: map['cnpj'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'cnpj': cnpj};

  SubEnterpriseEntity toEntity() =>
      SubEnterpriseEntity(id: id, name: name, cnpj: cnpj);

  factory SupabaseSubEnterpriseModel.fromEntity(SubEnterpriseEntity entity) {
    return SupabaseSubEnterpriseModel(
      id: entity.id,
      name: entity.name,
      cnpj: entity.cnpj,
    );
  }
}
