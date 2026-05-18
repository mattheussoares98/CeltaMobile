import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class PaymentsPage extends ConsumerStatefulWidget {
  const PaymentsPage({super.key});

  @override
  ConsumerState<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends ConsumerState<PaymentsPage> {
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
    return ResponsiveCenter(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Form(
        key: formKey,
        child: Consumer(
          builder: (_, ref, _) {
            String? errorMessage = ref.watch(
              insertUpdateStateControllerProvider.select((s) {
                if (s.value?.customer == null) {
                  return 'Informe o cliente'.hardcoded;
                } else if (s.value?.products?.isEmpty == true) {
                  return 'Informe pelo menos um produto'.hardcoded;
                }
                return null;
              }),
            );

            if (errorMessage != null) {
              return Center(
                child: Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.red,
                  ),
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                _NewPaymentSection(
                  creditCardController: creditCardController,
                  portionsController: portionsController,
                  validityController: validityController,
                  formKey: formKey,
                ),
                const PaymentsList(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NewPaymentSection extends ConsumerWidget {
  final TextEditingController creditCardController;
  final TextEditingController portionsController;
  final TextEditingController validityController;
  final GlobalKey<FormState> formKey;

  const _NewPaymentSection({
    required this.creditCardController,
    required this.portionsController,
    required this.validityController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalLiquidAndPaidDifference = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) =>
            (s.value?.totalProductsLiquid ?? 0) - (s.value?.totalPayments ?? 0),
      ),
    );

    if (totalLiquidAndPaidDifference == 0) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    } else if (totalLiquidAndPaidDifference < 0) {
      return SliverToBoxAdapter(
        child: Text(
          'O total das formas de pagamento está maior que o total dos produtos!'
              .hardcoded,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.red,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Text(
            'Nova forma de pagamento'.hardcoded,
            style: theme.textTheme.titleSmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TitleAndSubTitle(
            title: totalLiquidAndPaidDifference > 0
                ? 'Faltando'.hardcoded
                : 'Sobrando'.hardcoded,
            subTitle: totalLiquidAndPaidDifference.abs(),
            subTitleIsPrice: true,
            removeColon: true,
            subTitleStyle: theme.textTheme.titleMedium?.copyWith(
              color: Colors.red,
            ),
          ),
        ),
        gapSliverH8,
        const SliverToBoxAdapter(child: PaymentMethodDropdown()),
        gapSliverH8,
        const SliverToBoxAdapter(child: CovenantDropdown()),
        // SliverToBoxAdapter(
        //   child: PrimaryButton(
        //     onPressed: () => ref.invalidate(
        //       paymentFinalizationsStateControllerProvider(
        //         enterpriseCode: widget.enterpriseCode,
        //         customerCode: widget.customerCode,
        //         saleRequestCode: widget.saleRequestId,
        //       ),
        //     ),
        //     text: 'Recarregar formas de pagamento',
        //   ),
        // ),
        gapSliverH8,
        CreditCardFields(
          creditCardController: creditCardController,
          portionsController: portionsController,
          validityController: validityController,
        ),
        const PaymentConditionDropdown(),
        // SliverToBoxAdapter(
        //   child: PrimaryButton(
        //     onPressed: () =>
        //         ref.invalidate(paymentConditionsStateControllerProvider),
        //     text: 'Recarregar condições de pagamento',
        //   ),
        // ),
        SliverToBoxAdapter(
          child: ValueFieldAndConfirmButton(
            formKey: formKey,
            creditCardController: creditCardController,
            portionsController: portionsController,
            validityController: validityController,
          ),
        ),
        const SliverToBoxAdapter(child: Divider()),
      ],
    );
  }
}
