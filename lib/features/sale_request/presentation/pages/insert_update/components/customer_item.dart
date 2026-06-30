import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerItem extends ConsumerWidget {
  final BSFCustomerEntity customer;
  final bool toggleable;
  const CustomerItem({
    super.key,
    required this.customer,
    this.toggleable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.customer?.code == customer.code,
      ),
    );

    final hasCovenants =
        customer.covenants != null && customer.covenants!.isNotEmpty;

    return BaseRadio<bool>(
      name: customer.name ?? '',
      toggleable: toggleable,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (customer.cnpjCpfNumber != null)
            Text(customer.cnpjCpfNumber!.toMaskedCnpjCpf()),
          if (hasCovenants) ...[
            const SizedBox(height: Sizes.p4),
            TitleAndSubTitle(
              title: null,
              subTitle: 'Convênios'.hardcoded,
              subTitleStyle: context.theme.textTheme.titleSmall?.copyWith(
                color: context.theme.primaryColorDark,
              ),
            ),
            const SizedBox(height: Sizes.p4),
            Consumer(
              builder: (context, ref, _) {
                final selectedCovenant = ref.watch(
                  insertUpdateStateControllerProvider.select(
                    (s) => s.value?.customer?.code == customer.code
                        ? s.value?.customer?.selectedCovenant
                        : null,
                  ),
                );

                final allowedCovenantes = customer.covenants!.where((e) {
                  return e.isFired != true &&
                      (e.saleBlockade?.allowSale ?? true) &&
                      (e.dismissalDate?.isBefore(DateTime(0002)) ?? true);
                }).toList();
                return BaseChoiceChip<BsfCovenantEntity>(
                  items: allowedCovenantes,
                  selectedValue: selectedCovenant,
                  allowNullSelection: true,
                  onChanged: (covenant) async {
                    final notifier = ref.read(
                      insertUpdateStateControllerProvider.notifier,
                    );
                    final actions = notifier.updateCustomerOrCovenant(
                      customer,
                      covenant: covenant,
                      onlyValidating: true,
                      isChangingCovenant: true,
                    );
                    if (actions.isNotEmpty) {
                      final isBlocked = actions.any(
                        (a) =>
                            a.type ==
                            BSFSaleRequestSanitizationType.customerBlocked,
                      );

                      if (isBlocked) {
                        await showAlertDialog(
                          context: context,
                          title: 'Cliente Bloqueado'.hardcoded,
                          content: actions
                              .firstWhere(
                                (a) =>
                                    a.type ==
                                    BSFSaleRequestSanitizationType
                                        .customerBlocked,
                              )
                              .message,
                          defaultActionText: 'Entendido'.hardcoded,
                        );
                        return;
                      }

                      final confirmed = await showAlertDialog(
                        context: context,
                        title: 'Alteração do cliente'.hardcoded,
                        content:
                            'Esta alteração terá os seguintes impactos no pedido:\n\n'
                                    '${actions.map((a) => '• ${a.message}').join('\n')}\n\n'
                                    'Deseja prosseguir?'
                                .hardcoded,
                        cancelActionText: 'Cancelar'.hardcoded,
                        defaultActionText: 'Confirmar'.hardcoded,
                      );

                      if (confirmed != true) return;
                    }
                    notifier.updateCustomerOrCovenant(
                      customer,
                      covenant: covenant,
                      onlyValidating: false,
                      isChangingCovenant: true,
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
      value: true,
      groupValue: enabled,
      onChanged: toggleable
          ? (_) async {
              final notifier = ref.read(
                insertUpdateStateControllerProvider.notifier,
              );

              final actions = notifier.updateCustomerOrCovenant(
                customer,
                onlyValidating: true,
              );

              if (actions.isNotEmpty) {
                final isBlocked = actions.any(
                  (a) =>
                      a.type == BSFSaleRequestSanitizationType.customerBlocked,
                );

                if (isBlocked) {
                  await showAlertDialog(
                    context: context,
                    title: 'Cliente Bloqueado'.hardcoded,
                    content: actions
                        .firstWhere(
                          (a) =>
                              a.type ==
                              BSFSaleRequestSanitizationType.customerBlocked,
                        )
                        .message,
                    defaultActionText: 'Entendido'.hardcoded,
                  );
                  return;
                }

                final confirmed = await showAlertDialog(
                  context: context,
                  title: 'Alteração do cliente'.hardcoded,
                  content:
                      'Esta alteração terá os seguintes impactos no pedido:\n\n'
                              '${actions.map((a) => '• ${a.message}').join('\n')}\n\n'
                              'Deseja prosseguir?'
                          .hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Confirmar'.hardcoded,
                );

                if (confirmed != true) return;
              }

              notifier.updateCustomerOrCovenant(
                customer,
                onlyValidating: false,
              );
            }
          : null,
    );
  }
}
