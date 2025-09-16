import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';

class SelectEnterpriseDropDown extends ConsumerWidget {
  final List<EnterpriseEntity> enterprises;
  final EnterpriseEntity? selectedEnterprise;
  const SelectEnterpriseDropDown({
    super.key,
    required this.selectedEnterprise,
    required this.enterprises,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return DefaultDropDown<EnterpriseEntity>(
      hint: Text('Selecione a empresa'.hardcoded),
      selectedItem: selectedEnterprise,
      label: selectedEnterprise != null
          ? '${selectedEnterprise!.Code} - ${selectedEnterprise!.name}'
          : null,
      onChanged: (enterprise) {
        ref
            .read(selectedEnterpriseStateControllerProvider.notifier)
            .selectEnterprise(enterprise);
      },
      items: enterprises.map((e) {
        Color getColor(bool enabled) {
          if (enabled == false) {
            return Colors.red;
          } else if (e.Code == selectedEnterprise?.Code) {
            return theme.primaryColor;
          }

          return theme.disabledColor;
        }

        return DropdownMenuItem(
          value: e,
          enabled: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${e.Code} - ${e.name}',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: getColor(true),
                ),
              ),
              Text(
                "CNPJ ${e.CnpjNumber}",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: getColor(true),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
