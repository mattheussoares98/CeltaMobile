import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentConditionDropdown extends ConsumerWidget {
  const PaymentConditionDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBilletType = ref.watch(
      selectedPaymentTypeStateControllerProvider.select(
        (s) => s?.action?.type == PaymentFinalizationActionType.portion,
      ),
    );

    if (!selectedBilletType) {
      return const SizedBox.shrink();
    }

    return AsyncValueWidget(
      value: ref.watch(filteredPaymentConditionsStateControllerProvider),
      tryAgain: () =>
          ref.invalidate(filteredPaymentConditionsStateControllerProvider),
      data: (data) {
        if (data.isEmpty) {
          return const _NotFoundPaymentConditions();
        }

        final items = data
            .map(
              (e) => DropdownMenuItem<BSFPaymentConditionEntity>(
                value: e,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: context.theme.textTheme.bodyMedium,
                      children: [
                        if (e.personalizedCode.isNotEmpty)
                          TextSpan(
                            text: '${e.personalizedCode} - ',
                            style: context.theme.textTheme.titleSmall,
                          ),
                        TextSpan(text: e.description),
                        if ((e.condition?.composition ?? "0") != "0")
                          TextSpan(
                            text: ' ${e.condition?.composition}',
                            style: context.theme.textTheme.titleSmall?.copyWith(
                              color: context.theme.primaryColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: Sizes.p8),
          child: Consumer(
            builder: (_, ref, _) {
              final selectedItem = ref.watch(
                selectedPaymentConditionStateControllerProvider,
              );
              return DefaultDropDown<BSFPaymentConditionEntity>(
                onChanged: ref
                    .read(
                      selectedPaymentConditionStateControllerProvider.notifier,
                    )
                    .select,
                showLabelAtTopLeft: true,
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
        );
      },
    );
  }
}

class _NotFoundPaymentConditions extends ConsumerWidget {
  const _NotFoundPaymentConditions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
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
              ref.invalidate(filteredPaymentConditionsStateControllerProvider),
        ),
      ],
    );
  }
}
