import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/domain/entities/entities.dart';

class PaymentConditionDropdown extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const PaymentConditionDropdown({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBilletType = ref.watch(
      selectedPaymentTypeStateControllerProvider(
        saleRequestId,
      ).select((s) => s?.action?.type == PaymentFinalizationActionType.portion),
    );

    if (!selectedBilletType) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final provider = filteredPaymentConditionsStateControllerProvider(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );

    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(provider),
      tryAgain: () => ref.invalidate(provider),
      data: (data) {
        if (data.isEmpty) {
          return _NotFoundPaymentConditions(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
          );
        }

        final theme = Theme.of(context);

        final items = data
            .map(
              (e) => DropdownMenuItem<BSFPaymentConditionEntity>(
                value: e,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        if (e.personalizedCode.isNotEmpty)
                          TextSpan(
                            text: '${e.personalizedCode} - ',
                            style: theme.textTheme.titleSmall,
                          ),
                        TextSpan(text: e.description),
                        if ((e.condition?.composition ?? "0") != "0")
                          TextSpan(
                            text: ' ${e.condition?.composition}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList();

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: Consumer(
              builder: (_, ref, _) {
                final selectedItem = ref.watch(
                  selectedPaymentConditionStateControllerProvider,
                );
                return DefaultDropDown<BSFPaymentConditionEntity>(
                  onChanged: ref
                      .read(
                        selectedPaymentConditionStateControllerProvider
                            .notifier,
                      )
                      .select,
                  hint: Text('Condição de pagamento'.hardcoded),
                  selectedItem: selectedItem,
                  validator: (_) {
                    if (selectedItem == null) {
                      return 'Selecione uma forma de pagamento'.hardcoded;
                    }
                    return null;
                  },
                  label: 'Condição de pagamento'.hardcoded,
                  items: items,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _NotFoundPaymentConditions extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const _NotFoundPaymentConditions({
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Text(
            'Nenhuma condição de pagamento disponível. Somente condições de pagamento com composição fixas aparecerão'
                .hardcoded,
            textAlign: TextAlign.center,
          ),
          gapH8,
          Text(
            'Para cadastrar uma condição com composição fixa, acesse o CeltaBS e vá em "Cadastros > Financeiro > Condições de pagamento'
                .hardcoded,
          ),
          gapH8,
          PrimaryButton(
            text: 'Carregar novamente'.hardcoded,
            onPressed: () => ref.invalidate(
              filteredPaymentConditionsStateControllerProvider(
                enterpriseCode: enterpriseCode,
                customerCode: customerCode,
                saleRequestId: saleRequestId,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
