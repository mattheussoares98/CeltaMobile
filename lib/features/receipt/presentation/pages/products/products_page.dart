import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entity/entity.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ProductsPage extends StatelessWidget {
  final int receiptCode;
  final ReceiptEntity? receipt;
  final int enterpriseCode;
  const ProductsPage({
    super.key,
    required this.receiptCode,
    required this.receipt,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.goodsReceiving,
      Modules.receipt,
    );

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: AppBarTitle(receipt: receipt)),
          body: Column(
            children: [
              TopButtons(
                searchProductKey: searchProductKey,
                enterpriseCode: enterpriseCode,
                receiptCode: receiptCode,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.p8,
                    0,
                    Sizes.p8,
                    Sizes.p8,
                  ),
                  child: Column(
                    children: [
                      SearchProducts(
                        searchProductKey: searchProductKey,
                        receiptCode: receiptCode,
                      ),
                      gapH8,
                      Expanded(
                        child: ProductsItems(
                          searchProductKey: searchProductKey,
                          receiptCode: receiptCode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        LoadingPage(
          providers: [updateProductControllerProvider(searchProductKey)],
        ),
      ],
    );
  }
}
