import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ModulePermissionValue { inherit, trueValue, falseValue }

class EditSubEnterprisesSegmentedButttons extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    Color getThumbColor(ModulePermissionValue value) {
      if (value == ModulePermissionValue.trueValue) return Colors.green;
      if (value == ModulePermissionValue.falseValue) return Colors.red;
      return context.theme.disabledColor;
    }

    final isAdminLogin = ref.watch(
      authManagerStateProvider.select(
        (s) => s.value?.email?.toLowerCase() == 'admin@celtaware.com.br',
      ),
    );

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
            if (isAdminLogin) {
              onChange(module.id, getValue(newValue!));
            } else {
              showAlertDialog(
                context: context,
                title: 'Sem permissão'.hardcoded,
                content: 'Somente administradores podem fazer essa alteração'
                    .hardcoded,
              );
            }
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefaultText.titleMedium(module.name, textAlign: TextAlign.center),
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
      child: DefaultText(
        message,
        color: selected == true ? Colors.white : CupertinoColors.black,
      ),
    );
  }
}
