import '../../domain/entities/entities.dart';
import 'models.dart';

class EnterprisePermissionModel {
  final int id;
  final String name;
  final String baseUrl;
  final List<SubEnterprisePermissionModel> subEnterprises;

  EnterprisePermissionModel({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.subEnterprises,
  });

  factory EnterprisePermissionModel.fromJson(Map<String, dynamic> json) {
    return EnterprisePermissionModel(
      id: json['id'],
      name: json['name'],
      baseUrl: json['base_url'],
      subEnterprises: (json['sub_enterprises'] as List)
          .map((item) => SubEnterprisePermissionModel.fromJson(item))
          .toList(),
    );
  }

  factory EnterprisePermissionModel.fromEntity(
    EnterprisePermissionEntity entity,
  ) {
    return EnterprisePermissionModel(
      id: entity.id,
      name: entity.name,
      baseUrl: entity.baseUrl,
      subEnterprises: entity.subEnterprises
          .map((e) => SubEnterprisePermissionModel.fromEntity(e))
          .toList(),
    );
  }

  EnterprisePermissionEntity toEntity() {
    return EnterprisePermissionEntity(
      id: id,
      name: name,
      baseUrl: baseUrl,
      subEnterprises: subEnterprises.map((e) => e.toEntity()).toList(),
    );
  }
}
