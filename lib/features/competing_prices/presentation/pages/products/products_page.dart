import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Preços alterados com sucesso'.hardcoded,
      );
    });

    ref.observeLoading([updatePricesControllerProvider]);

    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      resizeToAvoidBottomInset: true,
      appBar: BaseAppBar(
        showSelectedEnterprise: false,
        subtitle: AppBarTitle(widget: this),
      ),
      body: ResponsiveScrollableWidget(
        isSliverPage: true,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Filters(
                enterpriseCode: enterpriseCode,
                researchCode: researchCode,
                concurrentCode: concurrentCode,
              ),
            ),
            SliverToBoxAdapter(
              child: SearchProductsField(
                enterpriseCode: enterpriseCode,
                researchCode: researchCode,
                concurrentCode: concurrentCode,
              ),
            ),
            gapSliverH8,
            ProductsItems(
              enterpriseCode: enterpriseCode,
              researchCode: researchCode,
              concurrentCode: concurrentCode,
            ),
          ],
        ),
      ),
    );
  }
}
