import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/data/datasource/products/products.dart';
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
  var searchType =
      SearchProductCompetingPriceType.all; //TODO create a controller for this

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
        padding: const EdgeInsets.fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p8),
        child: Column(
          children: [
            SearchProductsField(
              enterpriseCode: widget.enterpriseCode,
              competingPricesFilters: CompetingPricesFilters(
                ResearchOfPriceCode: widget.researchCode,
                ConcurrentCode: widget.concurrentCode,
                OnlyAssociated: widget.restrictProducts,
                searchType: searchType,
              ),
              searchValueController: searchValueController,
            ),
            gapH8,
            SearchTypeSegmentedButtons(
              searchType: searchType,
              onChange: (value) {
                setState(() {
                  searchType = value;
                });
              },
            ),
            gapH8,
            ProductsItems(enterpriseCode: widget.enterpriseCode),
          ],
        ),
      ),
    );
  }
}
