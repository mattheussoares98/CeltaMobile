class ModulePermissionEntity {
  final int id;
  final String moduleKey;
  final String name;
  final bool isEnabled;

  ModulePermissionEntity({
    required this.id,
    required this.moduleKey,
    required this.name,
    required this.isEnabled,
  });
}
