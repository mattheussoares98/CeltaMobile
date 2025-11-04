import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../controllers/controllers.dart';
import '../products/components/components.dart';

mixin SearchProductsListenerMixin {
  void listenSearchProducts({
    required WidgetRef ref,
    required BuildContext context,
    required TextEditingController searchValueController,
    required FocusNode focusNode,
    required int stepCode,
    required int expeditionControlCode,
    required int enterpriseCode,
  }) {
    ref.listen(
      searchProductsStateControllerProvider(
        enterpriseCode,
        BsRoutine.generic,
        Modules.expeditionConference,
      ),
      (p, n) {
        n.showSnackbarOnError(context,  p);

        n.doOnSuccess(p, () {
          if (n.value != null && n.value!.length == 1) {
            ref
                .read(
                  expeditionConferenceControllerProvider(
                    expeditionControlCode,
                  ).notifier,
                )
                .scanProduct(n.value!.first.ProductPackingCode, stepCode);

            Future.delayed(const Duration(milliseconds: 100), () {
              focusNode.requestFocus();
            });
          } else if (n.value != null && n.value!.length > 1) {
            showModalPage(
              SelectProductModalPage(
                n: n,
                expeditionControlCode: expeditionControlCode,
                stepCode: stepCode,
              ),
              context,
            );
          }
          searchValueController.clear();
        });
      },
    );
  }
}
