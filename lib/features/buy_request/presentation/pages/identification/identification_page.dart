import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import 'components/components.dart';

class IdentificationPage extends ConsumerStatefulWidget {
  const IdentificationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IdentificationPageState();
}

class _IdentificationPageState extends ConsumerState<IdentificationPage> {
  final supplierController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    supplierController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: ResponsiveScrollableWidget(
          isSliverPage: true,
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              const BuyersDropdown(),
              gapSliverH8,
              const RequestTypeDropdown(),
              gapSliverH8,
              SupplierSearcher(supplierController: supplierController),
              const SupplierItems(),
            ],
          ),
        ),
      ),
    );
  }
}
