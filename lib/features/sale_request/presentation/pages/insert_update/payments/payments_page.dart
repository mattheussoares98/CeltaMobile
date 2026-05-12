import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class PaymentsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const PaymentsPage({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

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
              insertUpdateStateControllerProvider(
                enterpriseCode: widget.enterpriseCode,
                customerCode: widget.customerCode,
                saleRequestId: widget.saleRequestId,
              ).select((s) {
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
                  enterpriseCode: widget.enterpriseCode,
                  customerCode: widget.customerCode,
                  saleRequestId: widget.saleRequestId,
                  creditCardController: creditCardController,
                  portionsController: portionsController,
                  validityController: validityController,
                  formKey: formKey,
                ),
                PaymentsList(
                  enterpriseCode: widget.enterpriseCode,
                  customerCode: widget.customerCode,
                  saleRequestId: widget.saleRequestId,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NewPaymentSection extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  final TextEditingController creditCardController;
  final TextEditingController portionsController;
  final TextEditingController validityController;
  final GlobalKey<FormState> formKey;

  const _NewPaymentSection({
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
    required this.creditCardController,
    required this.portionsController,
    required this.validityController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalLiquidAndPaidDifference = ref.watch(
      insertUpdateStateControllerProvider(
        enterpriseCode: enterpriseCode,
        customerCode: customerCode,
        saleRequestId: saleRequestId,
      ).select(
        (s) =>
            (s.value?.totalProductsLiquid ?? 0) - (s.value?.totalPayments ?? 0),
      ),
    );

    if (totalLiquidAndPaidDifference == 0) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
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
        SliverToBoxAdapter(
          child: PaymentMethodDropdown(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestCode: saleRequestId,
          ),
        ),
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
          saleRequestId: saleRequestId,
        ),
        PaymentConditionDropdown(
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestId: saleRequestId,
        ),
        // SliverToBoxAdapter(
        //   child: PrimaryButton(
        //     onPressed: () =>
        //         ref.invalidate(paymentConditionsStateControllerProvider),
        //     text: 'Recarregar condições de pagamento',
        //   ),
        // ),
        SliverToBoxAdapter(
          child: ValueFieldAndConfirmButton(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
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
