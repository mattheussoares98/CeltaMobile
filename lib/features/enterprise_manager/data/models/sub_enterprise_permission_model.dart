import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class SubEnterprisePermissionModel extends Equatable {
  final String id;
  final String name;
  final String cnpjNumber;
  final List<ModulePermissionModel> modules;

  const SubEnterprisePermissionModel({
    required this.id,
    required this.name,
    required this.cnpjNumber,
    required this.modules,
  });

  @override
  List<Object?> get props => [id, name, cnpjNumber, modules];

  factory SubEnterprisePermissionModel.fromJson(Map<String, dynamic> json) {
    return SubEnterprisePermissionModel(
      id: json['id'],
      name: json['name'],
      cnpjNumber: json['cnpj_number'],
      modules: (json['modules'] as List)
          .map((item) => ModulePermissionModel.fromJson(item))
          .toList(),
    );
  }

  factory SubEnterprisePermissionModel.fromEntity(
    SubEnterprisePermissionEntity entity,
  ) {
    return SubEnterprisePermissionModel(
      id: entity.id,
      name: entity.name,
      cnpjNumber: entity.cnpjNumber,
      modules: entity.modules
          .map((e) => ModulePermissionModel.fromEntity(e))
          .toList(),
    );
  }

  SubEnterprisePermissionEntity toEntity() {
    return SubEnterprisePermissionEntity(
      id: id,
      name: name,
      cnpjNumber: cnpjNumber,
      modules: modules.map((e) => e.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'cnpj_number': cnpjNumber,
    'modules': modules.map((e) => e.toJson()).toList(),
  };
}
