import 'package:celta_inventario/localization/string_hardcoded.dart';
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

  ModulePermissionValue getModulePermissionValue(bool? value) {
    if (value == true) {
      return ModulePermissionValue.trueValue;
    } else if (value == false) {
      return ModulePermissionValue.falseValue;
    } else {
      return ModulePermissionValue.inherit;
    }
  }

  bool? getValue(ModulePermissionValue value) {
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

        final groupValue = getModulePermissionValue(value);

        return _Module(
          key: ValueKey(module.id),
          value: value,
          module: module,
          groupValue: groupValue,
          onValueChanged: (newValue) {
            onChange(module.id, getValue(newValue!));
          },
          thumbColor: getThumbColor(groupValue),
        );
      },
    );
  }
}

class _Module extends StatelessWidget {
  final bool? value;
  final ModulePermissionEntity module;
  final ModulePermissionValue groupValue;
  final void Function(ModulePermissionValue? newValue) onValueChanged;
  final Color thumbColor;
  const _Module({
    super.key,
    required this.value,
    required this.module,
    required this.groupValue,
    required this.onValueChanged,
    required this.thumbColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: Card(
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
                groupValue: groupValue,
                onValueChanged: onValueChanged,
                thumbColor: thumbColor,
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
      ),
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
