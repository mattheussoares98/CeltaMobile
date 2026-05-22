import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/data/models/models.dart';

class SubEnterprisePermissionModel extends Equatable {
  final int id;
  final String name;
  final String cnpjNumber;
  final String personalizedCode;
  final List<ModulePermissionModel> modules;

  const SubEnterprisePermissionModel({
    required this.id,
    required this.name,
    required this.cnpjNumber,
    required this.personalizedCode,
    required this.modules,
  });

  @override
  List<Object?> get props => [id, name, cnpjNumber, modules, personalizedCode];

  factory SubEnterprisePermissionModel.fromJson(Map json) {
    return SubEnterprisePermissionModel(
      id: json['id'],
      name: json['name'],
      cnpjNumber: json['cnpj_number'],
      personalizedCode: json['personalized_code'],
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
      personalizedCode: entity.personalizedCode,
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
      personalizedCode: personalizedCode,
      modules: modules.map((e) => e.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'cnpj_number': cnpjNumber,
    'personalized_code': personalizedCode,
    'modules': modules.map((e) => e.toJson()).toList(),
  };
}
