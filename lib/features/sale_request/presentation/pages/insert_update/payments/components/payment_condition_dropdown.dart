import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class PaymentConditionDropdown extends ConsumerWidget {
  final int saleRequestId;
  const PaymentConditionDropdown({super.key, required this.saleRequestId});

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

    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(paymentConditionsStateControllerProvider),
      tryAgain: () => ref.invalidate(paymentConditionsStateControllerProvider),
      data: (data) {
        if (data.isEmpty) {
          return const _NotFoundPaymentConditions();
        }

        final theme = Theme.of(context);

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: Consumer(
              builder: (_, ref, _) {
                return DefaultDropDown<BSFPaymentConditionEntity>(
                  onChanged: ref
                      .read(
                        selectedPaymentConditionStateControllerProvider
                            .notifier,
                      )
                      .select,
                  hint: Text('Condição de pagamento'.hardcoded),
                  selectedItem: ref.watch(
                    selectedPaymentConditionStateControllerProvider,
                  ),
                  label: 'Condição de pagamento'.hardcoded,
                  items: data
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
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(color: theme.primaryColor),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
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
  const _NotFoundPaymentConditions();

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
            onPressed: () =>
                ref.invalidate(paymentConditionsStateControllerProvider),
          ),
        ],
      ),
    );
  }
}
