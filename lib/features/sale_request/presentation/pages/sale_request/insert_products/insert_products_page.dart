import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import 'components/components.dart';

class InsertProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final RequestTypeEntity selectedRequest;
  const InsertProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedRequest,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertProductsPageState();
}

class _InsertProductsPageState extends ConsumerState<InsertProductsPage> {
  final searchProductsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchProductsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Column(
        children: [
          SearchProducts(
            enterpriseCode: widget.enterpriseCode,
            searchProductsController: searchProductsController,
          ),
          gapH8,
          Expanded(
            child: ProductsItems(
              enterpriseCode: widget.enterpriseCode,
              requestCode: widget.selectedRequest.Code,
            ),
          ),
        ],
      ),
    );
  }
}
