import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

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
        final currentValue = ref.read(selectedItemUIControllerProvider);
        ref
            .read(selectedItemUIControllerProvider.notifier)
            .updateSelectedIndex(
              currentValue.selectedIndex,
            ); //remove the selected index when is equal the previous
      });
      n.showAlertDialogOnError(context);
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Preços alterados com sucesso'.hardcoded,
      );
    });

    ref.observeLoading([updatePricesControllerProvider]);

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(widget: this),
        toolbarHeight: researchName != null && concurrentName != null
            ? 66
            : null,
      ),
      body: ResponsiveScrollableWidget(
        isSliverPage: true,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Filters(widget: this)),
            SliverToBoxAdapter(child: SearchProductsField(widget: this)),
            gapSliverH8,
            ProductsItems(widget: this),
            gapSliverH48,
          ],
        ),
      ),
    );
  }
}
