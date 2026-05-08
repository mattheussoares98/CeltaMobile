import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
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
      child: CustomScrollView(
        slivers: [
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
          //       paymentOptionsStateControllerProvider(
          //         enterpriseCode: widget.enterpriseCode,
          //         customerCode: widget.customerCode,
          //         saleRequestCode: widget.saleRequestId,
          //       ),
          //     ),
          //     text: 'Recarregar',
          //   ),
          // ),
          gapSliverH8,
          SliverToBoxAdapter(
            child: CreditCardFields(
              creditCardController: creditCardController,
              portionsController: portionsController,
              validityController: validityController,
              saleRequestId: widget.saleRequestId,
            ),
          ),
          SliverToBoxAdapter(
            child: ValueFieldAndConfirmButton(
              enterpriseCode: widget.enterpriseCode,
              customerCode: widget.customerCode,
              saleRequestId: widget.saleRequestId,
            ),
          ),
          const SliverToBoxAdapter(child: Divider()),
          PaymentsList(
            enterpriseCode: widget.enterpriseCode,
            customerCode: widget.customerCode,
            saleRequestId: widget.saleRequestId,
          ),
        ],
      ),
    );
  }
}
