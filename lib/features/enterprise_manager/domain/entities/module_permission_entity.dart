import 'package:equatable/equatable.dart';

class ModulePermissionEntity extends Equatable {
  final int id;
  final String moduleKey;
  final String name;
  final bool isEnabled;

  const ModulePermissionEntity({
    required this.id,
    required this.moduleKey,
    required this.name,
    required this.isEnabled,
  });

  @override
  List<Object?> get props => [id, moduleKey, name, isEnabled];
}
