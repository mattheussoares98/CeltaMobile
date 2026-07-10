import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin SearchProductsListenerMixin {
  void listenSearchProducts({
    required WidgetRef ref,
    required BuildContext context,
    required TextEditingController searchProductController,
    required int stepCode,
    required int expeditionControlCode,
    required int enterpriseCode,
    required FocusNode searchProductFocusNode,
  }) {
    ref.listen(
      searchProductsStateControllerProvider(
        SearchProductKey(
          enterpriseCode,
          BsRoutine.generic,
          Modules.expeditionConference,
        ),
      ),
      (p, n) {
        n.showToastOnError(context, p);

        n.doOnSuccess(p, () async {
          if (n.value != null && n.value!.length == 1) {
            bool succeeds = await ref
                .read(scanProductControllerProvider.notifier)
                .scan(
                  expeditionControlCode: expeditionControlCode,
                  productPackingCode: n.value!.first.ProductPackingCode!,
                  stepCode: stepCode,
                );

            if (succeeds) {
              Future.delayed(const Duration(milliseconds: 100), () {
                searchProductFocusNode.requestFocus();
              });
            }
          } else if (n.value != null && n.value!.length > 1) {
            showModalPage(
              SelectProductModalPage(
                products: n.value!,
                expeditionControlCode: expeditionControlCode,
                stepCode: stepCode,
              ),
              context,
            );
          }
          searchProductController.clear();
        });
      },
    );
  }
}
