import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';

class EditModulePermissionButtons extends StatelessWidget {
  final void Function(int moduleId, bool? newValue) onChange;
  final List<ModulePermissionEntity> modulesToDisplay;
  final bool isGlobalChange;
  final Map<int, bool?> permissionChanges;
  const EditModulePermissionButtons({
    super.key,
    required this.onChange,
    required this.modulesToDisplay,
    required this.isGlobalChange,
    required this.permissionChanges,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveFlowLayout(
      items: modulesToDisplay.map((module) {
        final currentValue = permissionChanges[module.id];

        // If it's a GLOBAL change, show a simple Switch
        if (isGlobalChange) {
          return SwitchListTile(
            dense: true,
            title: Text(module.name),
            value: currentValue ?? false, // Default global to false
            onChanged: (newValue) {
              onChange(module.id, newValue);
            },
          );
        }
        // If it's a SPECIFIC CNPJ change, show the SegmentedButton
        else {
          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(module.name, style: theme.textTheme.titleMedium),
                gapH8,
                SegmentedButton<bool?>(
                  segments: [
                    ButtonSegment(
                      value: true,
                      label: Text('Habilitado'.hardcoded),
                    ),
                    ButtonSegment(value: null, label: Text('Herdar'.hardcoded)),
                    ButtonSegment(
                      value: false,
                      label: Text('Desabilitado'.hardcoded),
                    ),
                  ],
                  selected: {currentValue},
                  onSelectionChanged: (newSelection) {
                    onChange(module.id, newSelection.first);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        if (currentValue == true) {
                          return Colors.green.shade100;
                        }
                        if (currentValue == false) {
                          return Colors.red.shade100;
                        }
                        return Colors.blue.shade100;
                      }
                      return Colors.transparent;
                    }),
                  ),
                ),
              ],
            ),
          );
        }
      }).toList(),
    );
  }
}
