import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../domain/entities/entities.dart';

class EditEnterpriseSwitch extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ResponsiveListFlow(
      itemCount: modulesToDisplay.length,
      itemBuilder: (_, index) {
        final module = modulesToDisplay[index];
        final value = permissionChanges[module.id];

        return Card(
          child: SwitchListTile(
            activeThumbColor: Colors.green,
            inactiveThumbColor: Colors.redAccent,
            inactiveTrackColor: Colors.red.shade100,
            dense: true,
            title: Text(module.name),
            value: value ?? false, // Default global to false
            onChanged: (newValue) {
              onChange(module.id, newValue);
            },
          ),
        );
      },
    );
  }
}
