import 'package:celta_inventario/features/sale_request/presentation/localization/localization.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
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

                if (allowedCovenantes.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    gapH4,
                    TitleAndSubTitle(
                      title: null,
                      subTitle: context.l10n.agreements,
                      subTitleStyle: context.theme.textTheme.titleSmall
                          ?.copyWith(color: context.theme.primaryColorDark),
                    ),
                    gapH4,
                    BaseChoiceChip<BsfCovenantEntity>(
                      items: allowedCovenantes,
                      selections: [?selectedCovenant],
                      itemLabelBuilder: (item) => item.name,
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
                              title: context.l10n.customerBlocked,
                              content: context.l10n.sanitizationActionMessage(
                                actions.firstWhere(
                                  (a) =>
                                      a.type ==
                                      BSFSaleRequestSanitizationType
                                          .customerBlocked,
                                ),
                              ),
                              defaultActionText: context.l10n.understood,
                            );
                            return;
                          }

                          final confirmed = await showAlertDialog(
                            context: context,
                            title: context.l10n.customerChange,
                            content: context.l10n.confirmOrderChangeImpacts(
                              actions
                                  .map(
                                    (a) =>
                                        '• ${context.l10n.sanitizationActionMessage(a)}',
                                  )
                                  .join('\n'),
                            ),
                            cancelActionText: context.l10n.cancel,
                            defaultActionText: context.l10n.confirm,
                          );

                          if (confirmed != true) return;
                        }
                        notifier.updateCustomerOrCovenant(
                          customer,
                          covenant: covenant,
                          isChangingCovenant: true,
                        );
                      },
                    ),
                  ],
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
                    title: context.l10n.customerBlocked,
                    content: context.l10n.sanitizationActionMessage(
                      actions.firstWhere(
                        (a) =>
                            a.type ==
                            BSFSaleRequestSanitizationType.customerBlocked,
                      ),
                    ),
                    defaultActionText: context.l10n.understood,
                  );
                  return;
                }

                final confirmed = await showAlertDialog(
                  context: context,
                  title: context.l10n.customerChange,
                  content: context.l10n.confirmOrderChangeImpacts(
                    actions
                        .map(
                          (a) =>
                              '• ${context.l10n.sanitizationActionMessage(a)}',
                        )
                        .join('\n'),
                  ),
                  cancelActionText: context.l10n.cancel,
                  defaultActionText: context.l10n.confirm,
                );

                if (confirmed != true) return;
              }

              notifier.updateCustomerOrCovenant(customer);
            }
          : null,
    );
  }
}
