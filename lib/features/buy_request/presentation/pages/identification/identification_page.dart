import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/identification/components/components.dart';

class IdentificationPage extends ConsumerWidget {
  final int enterpriseCode;
  const IdentificationPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: Column(
          children: [
            Column(
              children: [
                BuyersAndRequestsDropdown(
                  enabled: true,
                  enterpriseCode: enterpriseCode,
                ),
                gapH8,
                SupplierSearcher(enterpriseCode: enterpriseCode),
              ],
            ),
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SupplierItems(isSliver: true, enterpriseCode: enterpriseCode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
