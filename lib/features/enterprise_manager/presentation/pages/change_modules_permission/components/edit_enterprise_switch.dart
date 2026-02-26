import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class EditEnterpriseSwitch extends ConsumerWidget {
  final void Function(int moduleId, bool? newValue) onChange;
  final List<ModulePermissionEntity> modulesToDisplay;
  final Map<int, bool?> permissionChanges;
  const EditEnterpriseSwitch({
    super.key,
    required this.onChange,
    required this.modulesToDisplay,
    required this.permissionChanges,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdminLogin = ref.watch(
      authManagerStateProvider.select(
        (s) => s.value?.email?.toLowerCase() == 'telma@celtaware.com.br',
      ),
    );
    return ResponsiveListFlow(
      isSliver: true,
      itemCount: modulesToDisplay.length,
      itemBuilder: (_, index) {
        final module = modulesToDisplay[index];
        final value = permissionChanges[module.id];

        return _ModuleItem(
          key: ValueKey(module.id),
          value: value,
          isAdminLogin: isAdminLogin,
          onChanged: (newValue) {
            onChange(module.id, newValue);
          },
          module: module,
        );
      },
    );
  }
}

class _ModuleItem extends StatelessWidget {
  final bool? value;
  final void Function(bool)? onChanged;
  final ModulePermissionEntity module;
  final bool isAdminLogin;
  const _ModuleItem({
    super.key,
    required this.value,
    required this.onChanged,
    required this.module,
    required this.isAdminLogin,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: IgnorePointer(
        ignoring: !isAdminLogin,
        child: Card(
          child: SwitchListTile(
            activeThumbColor: Colors.green,
            inactiveThumbColor: Colors.redAccent,
            inactiveTrackColor: Colors.red.shade100,
            dense: true,
            title: Text(module.name),
            value: value ?? false, // Default global to false
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
