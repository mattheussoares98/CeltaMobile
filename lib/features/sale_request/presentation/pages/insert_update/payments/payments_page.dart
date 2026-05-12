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
            final alreadyPaidEverything = ref.watch(
              insertUpdateStateControllerProvider(
                enterpriseCode: widget.enterpriseCode,
                customerCode: widget.customerCode,
                saleRequestId: widget.saleRequestId,
              ).select(
                (s) => s.value?.totalProductsLiquid == s.value?.totalPayments,
              ),
            );

            return CustomScrollView(
              slivers: [
                if (!alreadyPaidEverything) ...[
                  SliverToBoxAdapter(
                    child: Text(
                      'Nova forma de pagamento'.hardcoded,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  gapSliverH8,
                  SliverToBoxAdapter(
                    child: PaymentMethodDropdown(
                      enterpriseCode: widget.enterpriseCode,
                      customerCode: widget.customerCode,
                      saleRequestCode: widget.saleRequestId,
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
                    saleRequestId: widget.saleRequestId,
                  ),
                  PaymentConditionDropdown(
                    enterpriseCode: widget.enterpriseCode,
                    customerCode: widget.customerCode,
                    saleRequestId: widget.saleRequestId,
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
                      enterpriseCode: widget.enterpriseCode,
                      customerCode: widget.customerCode,
                      saleRequestId: widget.saleRequestId,
                      formKey: formKey,
                      creditCardController: creditCardController,
                      portionsController: portionsController,
                      validityController: validityController,
                    ),
                  ),
                  const SliverToBoxAdapter(child: Divider()),
                ],
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
