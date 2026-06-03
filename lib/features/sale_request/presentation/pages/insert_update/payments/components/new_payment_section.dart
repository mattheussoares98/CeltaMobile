import 'package:celta_inventario/commom_widgets/title_and_subtitle.dart';
import 'package:celta_inventario/constants/app_sizes.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/payments/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPaymentSection extends ConsumerStatefulWidget {
  const NewPaymentSection({super.key});

  @override
  ConsumerState<NewPaymentSection> createState() => _NewPaymentSectionState();
}

class _NewPaymentSectionState extends ConsumerState<NewPaymentSection> {
  final creditCardController = TextEditingController();
  final portionsController = TextEditingController();
  final validityController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    creditCardController.dispose();
    portionsController.dispose();
    validityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValidPayment = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.isPaymentValid ?? false,
      ),
    );

    final totalLiquidAndPaidDifference = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.totalLiquidAndPaidDifference ?? 0,
      ),
    );

    if (totalLiquidAndPaidDifference == 0 && isValidPayment) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    if (totalLiquidAndPaidDifference < 0) {
      return SliverToBoxAdapter(
        child: Text(
          'O total das formas de pagamento está maior que o total dos produtos!'
              .hardcoded,
          textAlign: TextAlign.center,
          style: context.theme.textTheme.titleSmall?.copyWith(
            color: Colors.red,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Card(
        margin: const EdgeInsets.only(bottom: Sizes.p8),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Nova forma de pagamento'.hardcoded,
                      style: context.theme.textTheme.titleSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  gapW16,
                  Expanded(
                    flex: 4,
                    child: TitleAndSubTitle(
                      title: totalLiquidAndPaidDifference > 0
                          ? 'Faltando'.hardcoded
                          : 'Sobrando'.hardcoded,
                      subTitle: totalLiquidAndPaidDifference.abs(),
                      subTitleIsPrice: true,
                      removeColon: true,
                      subTitleStyle: context.theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    gapH8,
                    const PaymentMethodDropdown(),
                    gapH8,
                    const CovenantDropdown(),
                    gapH8,
                    CreditCardFields(
                      creditCardController: creditCardController,
                      portionsController: portionsController,
                      validityController: validityController,
                    ),
                    const PaymentConditionDropdown(),
                    ValueFieldAndConfirmButton(
                      formKey: formKey,
                      creditCardController: creditCardController,
                      portionsController: portionsController,
                      validityController: validityController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
