import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';

enum ModulePermissionValue { inherit, trueValue, falseValue }

class EditSubEnterprisesSegmentedButttons extends StatelessWidget {
  final void Function(int moduleId, bool? newValue) onChange;
  final List<ModulePermissionEntity> modulesToDisplay;
  final Map<int, bool?> permissionChanges;
  const EditSubEnterprisesSegmentedButttons({
    super.key,
    required this.onChange,
    required this.modulesToDisplay,
    required this.permissionChanges,
  });

  ModulePermissionValue getModulePermissionModule(bool? value) {
    if (value == true) {
      return ModulePermissionValue.trueValue;
    } else if (value == false) {
      return ModulePermissionValue.falseValue;
    } else {
      return ModulePermissionValue.inherit;
    }
  }

  bool? getModulePermissionValue(ModulePermissionValue value) {
    if (value == ModulePermissionValue.trueValue) return true;
    if (value == ModulePermissionValue.falseValue) return false;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color getThumbColor(ModulePermissionValue value) {
      if (value == ModulePermissionValue.trueValue) return Colors.green;
      if (value == ModulePermissionValue.falseValue) return Colors.red;
      return theme.disabledColor;
    }

    return ResponsiveListFlow(
      isSliver: true,
      itemCount: modulesToDisplay.length,
      itemBuilder: (_, index) {
        final module = modulesToDisplay[index];
        final value = permissionChanges[module.id];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  module.name,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                gapH8,
                CupertinoSlidingSegmentedControl<ModulePermissionValue>(
                  groupValue: getModulePermissionModule(value),
                  onValueChanged: (newValue) {
                    onChange(module.id, getModulePermissionValue(newValue!));
                  },
                  thumbColor: getThumbColor(getModulePermissionModule(value)),
                  children: <ModulePermissionValue, Widget>{
                    ModulePermissionValue.trueValue: _Item(
                      selected: value == true,
                      message: 'Habilitado'.hardcoded,
                    ),
                    ModulePermissionValue.inherit: _Item(
                      selected: value == null,
                      message: 'Herdar'.hardcoded,
                    ),
                    ModulePermissionValue.falseValue: _Item(
                      selected: value == false,
                      message: 'Desabilitado'.hardcoded,
                    ),
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  final bool? selected;
  final String message;
  const _Item({required this.selected, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p4,
        vertical: Sizes.p8,
      ),
      child: Text(
        message,
        style: TextStyle(
          color: selected == true ? Colors.white : CupertinoColors.black,
        ),
      ),
    );
  }
}
