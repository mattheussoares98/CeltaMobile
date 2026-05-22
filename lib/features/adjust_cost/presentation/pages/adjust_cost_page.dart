import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/pages/components/components.dart';

class AdjustCostPage extends ConsumerWidget {
  final int enterpriseCode;
  const AdjustCostPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(confirmAdjustCostControllerProvider(enterpriseCode), (p, n) {
      n.showAlertDialogOnError(context);
    });

    ref.observeLoading([confirmAdjustCostControllerProvider(enterpriseCode)]);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: DefaultAppBarTitle(
                title: 'Alterar custo de reposição'.hardcoded,
              ),
            ),
          ],
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
