import '../../domain/entities/entities.dart';
import 'models.dart';

class SubEnterprisePermissionModel {
  final int id;
  final String name;
  final String cnpjNumber;
  final List<ModulePermissionModel> modules;

  SubEnterprisePermissionModel({
    required this.id,
    required this.name,
    required this.cnpjNumber,
    required this.modules,
  });

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
}
