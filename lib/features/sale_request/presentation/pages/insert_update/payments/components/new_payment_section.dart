import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/title_and_subtitle.dart';
import 'package:celta_inventario/constants/app_sizes.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/payments/components/components.dart';
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
          context.l10n.paymentExceedsOrder +
              context.l10n.paymentDifference(
                totalLiquidAndPaidDifference
                    .abs()
                    .toString()
                    .toBrazilianNumber(),
              ),
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
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      context.l10n.newPaymentMethod,
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
                          ? context.l10n.missing
                          : context.l10n.excess,
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
