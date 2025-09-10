import 'package:equatable/equatable.dart';

class ModulePermissionEntity extends Equatable {
  final int id;
  final String moduleKey;
  final String name;
  final bool? isEnabled;
  final bool isDefinedAtCnpjLevel;

  const ModulePermissionEntity({
    required this.id,
    required this.moduleKey,
    required this.name,
    required this.isEnabled,
    required this.isDefinedAtCnpjLevel,
  });

  @override
  List<Object?> get props => [
    id,
    moduleKey,
    name,
    isEnabled,
    isDefinedAtCnpjLevel,
  ];
}
