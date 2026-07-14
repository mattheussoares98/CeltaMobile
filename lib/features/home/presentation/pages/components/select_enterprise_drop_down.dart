import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectEnterpriseDropDown extends ConsumerWidget {
  const SelectEnterpriseDropDown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(enterprisesStateControllerProvider()),
      tryAgain: null,
      errorMaxLines: 1,
      data: (enterprises) {
        final items = enterprises
            .map((e) {
              // Keep it simple: a single Text is much cheaper than RichText/TextSpan
              final text =
                  '${e.PersonalizedCode} - ${e.name} (${e.CnpjNumber})';

              return DropdownMenuItem<EnterpriseEntity>(
                value: e,
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.titleSmall,
                ),
              );
            })
            .toList(growable: false);

        return Consumer(
          builder: (context, ref, child) {
            final selectedEnterprise = ref.watch(
              selectedEnterpriseStateControllerProvider,
            );
            return RepaintBoundary(
              child: BaseDropDown<EnterpriseEntity>(
                hint: Text('Selecione a empresa'.hardcoded),
                selectedItem: selectedEnterprise,
                label: selectedEnterprise != null
                    ? '${selectedEnterprise.PersonalizedCode} - ${selectedEnterprise.name}'
                    : null,
                onChanged: (enterprise) async {
                  ref
                      .read(selectedEnterpriseStateControllerProvider.notifier)
                      .selectEnterprise(enterprise);
                },
                items: items,
              ),
            );
          },
        );
      },
    );
  }
}
