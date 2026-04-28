import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import 'components/components.dart';

class InsertProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  final BSFRequestTypeEntity selectedRequest;
  const InsertProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedRequest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Column(
        children: [
          SearchProducts(
            enterpriseCode: enterpriseCode,
            saleRequestId: selectedRequest.code!,
          ),
          gapH8,
          Expanded(
            child: CustomScrollView(
              slivers: [
                ProductsItems(
                  enterpriseCode: enterpriseCode,
                  requestCode: selectedRequest.code!,
                ),
                gapSliverH48,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
