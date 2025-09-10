import 'package:equatable/equatable.dart';

class UpdateModulePermissionModel extends Equatable {
  final int moduleId;
  final bool? isEnabled;
  final int? subEnterpriseId;

  const UpdateModulePermissionModel({
    required this.moduleId,
    this.isEnabled,
    this.subEnterpriseId,
  });

  @override
  List<Object?> get props => [moduleId, isEnabled, subEnterpriseId];

  Map<String, dynamic> toJson() => {
    'module_id': moduleId,
    'is_enabled': isEnabled,
    'sub_enterprise_id': subEnterpriseId,
  };
}
