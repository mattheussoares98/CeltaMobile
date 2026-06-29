import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustCostPage extends ConsumerWidget {
  final int enterpriseCode;
  const AdjustCostPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(confirmAdjustCostControllerProvider(enterpriseCode), (p, n) {
      n.showAlertDialogOnError(context);
    });

    ref.observeLoading([confirmAdjustCostControllerProvider(enterpriseCode)]);

    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      resizeToAvoidBottomInset: true,
      appBar: BaseAppBar(
        title: 'Alterar custo de reposição'.hardcoded,
        showSelectedEnterprise: true,
      ),
      body: Column(
        children: [
          SearchField(enterpriseCode: enterpriseCode),
          ProductsItems(enterpriseCode: enterpriseCode),
        ],
      ),
    );
  }
}
