import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import 'components/components.dart';

class IdentificationPage extends ConsumerWidget {
  const IdentificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: ResponsiveScrollableWidget(
          isSliverPage: true,
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [
              BuyersDropdown(),
              gapSliverH8,
              RequestTypeDropdown(),
              gapSliverH8,
              SupplierSearcher(),
              SupplierItems(),
            ],
          ),
        ),
      ),
    );
  }
}
