import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../utils/utils.dart';
import 'components/components.dart';

class AssociatedsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int researchCode;
  final int concurrentCode;
  final bool restrictProducts;
  const AssociatedsPage({
    super.key,
    required this.enterpriseCode,
    required this.researchCode,
    required this.concurrentCode,
    required this.restrictProducts,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssociatedsPageState();
}

class _AssociatedsPageState extends ConsumerState<AssociatedsPage> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.researchOfPrice,
        Modules.competingPrices,
      ),
      (p, n) {
        n.doOnSuccess(p, () {
          searchValueController.clear();
        });
      },
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            ResponsiveScrollableWidget(
              padding: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SearchTypeSegmentedButtons(
                    enterpriseCode: widget.enterpriseCode,
                    researchCode: widget.researchCode,
                    concurrentCode: widget.concurrentCode,
                    restrictProducts: widget.restrictProducts,
                  ),
                  SearchProductsField(
                    enterpriseCode: widget.enterpriseCode,
                    researchCode: widget.researchCode,
                    concurrentCode: widget.concurrentCode,
                    restrictProducts: widget.restrictProducts,
                    searchValueController: searchValueController,
                  ),
                  gapH8,
                ],
              ),
            ),
            ProductsItems(enterpriseCode: widget.enterpriseCode),
          ],
        ),
      ),
    );
  }
}
