import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import 'components/components.dart';

class AdjustCostPage extends ConsumerWidget {
  final int enterpriseCode;
  const AdjustCostPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(
          title: 'Ajustar custo de reposição'.hardcoded,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: Column(
          children: [
            SearchField(enterpriseCode: enterpriseCode),
            ProductsItems(enterpriseCode: enterpriseCode),
          ],
        ),
      ),
    );
  }
}
