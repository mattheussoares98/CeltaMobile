import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import 'components/components.dart';

class PaymentsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      padding: const EdgeInsets.all(Sizes.p8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PaymentMethodDropdown(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestCode: saleRequestId,
            ),
          ),
          SliverToBoxAdapter(
            child: PaymentsForm(
              enterpriseCode: enterpriseCode,
              customerCode: customerCode,
              saleRequestId: saleRequestId,
            ),
          ),
          const SliverToBoxAdapter(child: Divider()),
          PaymentsList(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
          ),
        ],
      ),
    );
  }
}
