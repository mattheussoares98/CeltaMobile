import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/constants.dart';
import '../components/components.dart';
import 'components/components.dart';

class IdentificationPage extends ConsumerWidget {
  const IdentificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: Column(
          children: [
            Column(
              children: [
                BuyersAndRequestsDropdown(enabled: true),
                gapH8,
                SupplierSearcher(),
              ],
            ),
            Expanded(
              child: CustomScrollView(
                physics: ClampingScrollPhysics(),
                slivers: [SupplierItems(isSliver: true)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
