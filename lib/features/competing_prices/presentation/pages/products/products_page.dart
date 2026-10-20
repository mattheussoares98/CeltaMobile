import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  final int researchCode;
  final int concurrentCode;
  final String? researchName;
  final String? concurrentName;
  const ProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.researchCode,
    required this.concurrentCode,
    required this.researchName,
    required this.concurrentName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(updatePricesControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        ref
            .read(selectedItemUIControllerProvider.notifier)
            .updateSelectedIndex(null);
      });
      n.showAlertDialogOnError(context);
      n.showToastOnSuccess(
        context,
        previous: p,
        message: context.l10n.pricesChangedSuccessfully,
      );
    });

    ref.observeLoading([updatePricesControllerProvider]);

    return BaseScaffold(
      isScrollable: false,
      resizeToAvoidBottomInset: true,
      appBar: BaseAppBar(subtitle: AppBarTitle(widget: this)),
      body: Column(
        children: [
          SizedBox(
            width: Breakpoint.tablet,
            child: Column(
              children: [
                Filters(
                  enterpriseCode: enterpriseCode,
                  researchCode: researchCode,
                  concurrentCode: concurrentCode,
                ),
                SearchProductsField(
                  enterpriseCode: enterpriseCode,
                  researchCode: researchCode,
                  concurrentCode: concurrentCode,
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                gapSliverH8,
                ProductsItems(
                  enterpriseCode: enterpriseCode,
                  researchCode: researchCode,
                  concurrentCode: concurrentCode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
