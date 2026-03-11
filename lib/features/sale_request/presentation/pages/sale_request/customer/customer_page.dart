import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import 'components/components.dart';

class CustomerPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const CustomerPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerPageState();
}

class _CustomerPageState extends ConsumerState<CustomerPage> {
  final searchCustomerController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    searchCustomerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResponsiveScrollableWidget(
            child: SearchFieldAndSwitch(
              formKey: formKey,
              searchController: searchCustomerController,
              enterpriseCode: widget.enterpriseCode,
            ),
          ),
          Expanded(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                ConsumerCustomer(enterpriseCode: widget.enterpriseCode),
                gapSliverH8,
                CustomersItems(enterpriseCode: widget.enterpriseCode),
                gapSliverH80,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
