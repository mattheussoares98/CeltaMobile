import '../../domain/entities/entities.dart';

class SubEnterpriseModel {
  final String id;
  final String name;
  final String cnpj;
  SubEnterpriseModel({
    required this.id,
    required this.name,
    required this.cnpj,
  });

  factory SubEnterpriseModel.fromJson(Map<String, dynamic> map) {
    return SubEnterpriseModel(
      id: map['id'] as String,
      name: map['name'] as String,
      cnpj: map['cnpj'] as String,
    );
  }

  SubEnterpriseEntity toEntity() =>
      SubEnterpriseEntity(id: id, name: name, cnpj: cnpj);
}
