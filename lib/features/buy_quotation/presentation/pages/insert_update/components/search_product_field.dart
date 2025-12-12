import 'package:flutter/widgets.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';

class SearchProductField extends StatelessWidget {
  final int enterpriseCode;
  final TextEditingController searchValueController;
  const SearchProductField({
    super.key,
    required this.enterpriseCode,
    required this.searchValueController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: DefaultSearchProducts(
        isLoading: false, //TODO check to remove this property as param
        searchProducts: () {
          //TODO searchProducts
        },
        searchValueController: searchValueController,
        searchProductKey: SearchProductKey(
          enterpriseCode,
          BsRoutine.buyQuotation,
          Modules.buyQuotation,
        ),
      ),
    );
  }
}
