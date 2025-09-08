import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class SubEnterpriseModel extends Equatable {
  final String id;
  final String name;
  final String cnpj;
  const SubEnterpriseModel({
    required this.id,
    required this.name,
    required this.cnpj,
  });

  @override
  List<Object?> get props => [id, name, cnpj];

  factory SubEnterpriseModel.fromJson(Map<String, dynamic> map) {
    return SubEnterpriseModel(
      id: map['id'] as String,
      name: map['name'] as String,
      cnpj: map['cnpj'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'cnpj': cnpj};

  SubEnterpriseEntity toEntity() =>
      SubEnterpriseEntity(id: id, name: name, cnpj: cnpj);
}
