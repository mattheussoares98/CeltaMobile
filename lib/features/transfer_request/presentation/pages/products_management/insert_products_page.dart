import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';

class InsertProductsPage extends ConsumerWidget {
  final int enterpriseOriginCode;
  final int enterpriseDestinyCode;
  final int requestTypeCode;
  final TextEditingController searchValueController;
  const InsertProductsPage({
    super.key,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeCode,
    required this.searchValueController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DefaultSearchProducts(
          isLoading: false,
          searchProducts: () {},
          searchValueController: searchValueController,
        ),
      ],
    );
  }
}
