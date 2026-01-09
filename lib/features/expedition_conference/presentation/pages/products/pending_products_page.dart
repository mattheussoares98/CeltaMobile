import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../core/presentation/controllers/scanner/scanner.dart';
import '../../../../../utils/utils.dart';
import '../../../../settings/presentation/controllers/controllers.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class PendingProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  final FocusNode focusNode;
  final TextEditingController searchProductController;
  final int expeditionControlCode;
  const PendingProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.focusNode,
    required this.searchProductController,
    required this.expeditionControlCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.generic,
      Modules.expeditionConference,
    );

    void searchProducts(bool searchByCamera) async {
      focusNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 100));

      String? barcode;
      if (searchByCamera) {
        barcode = await ref.read(barcodeScannerStateControllerProvider.future);
        if (barcode == null) {
          return;
        } else {
          searchProductController.text = barcode;
        }
      }
      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .loadProducts(
            GetProductsJsonParams(
              searchValue: barcode ?? searchProductController.text,
              enterpriseCodes: [enterpriseCode],
            ),
          );
    }

    final isContinuousScan = ref.watch(
      appSettingsStateControllerProvider.select(
        (s) => s.value?.expeditionUseContinuousScan == true,
      ),
    );

    ref.listen(expeditionConferenceControllerProvider(expeditionControlCode), (
      p,
      n,
    ) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () async {
        double sumTotal(List<ExpeditionProductEntity> list) {
          return list.fold<double>(0.0, (p, e) => p + e.Quantity);
        }

        bool initialStateIsEqualPending =
            sumTotal(n.value!.initialProducts) ==
            sumTotal(n.value!.pendingProducts);

        if (n.value?.pendingProducts == null ||
            n.value!.pendingProducts.isEmpty ||
            initialStateIsEqualPending) {
          //avoid search products even didnt search anything
          return;
        }

        if (isContinuousScan && n.value != null) {
          await Future.delayed(const Duration(milliseconds: 500), () {
            searchProducts(true);
          });
        }
      });
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Column(
        children: [
          DefaultSearchProducts(
            searchProductKey: searchProductKey,
            module: Modules.expeditionConference,
            isLoading:
                ref.watch(
                  expeditionConferenceControllerProvider(
                    expeditionControlCode,
                  ).select((state) => state.isLoading),
                ) ||
                ref.watch(
                  searchProductsStateControllerProvider(
                    searchProductKey,
                  ).select((state) => state.isLoading),
                ) ||
                ref.watch(
                  confirmConferenceControllerProvider.select(
                    (state) => state.isLoading,
                  ),
                ),
            focusNode: focusNode,
            searchProducts: () => searchProducts(false),
            searchValueController: searchProductController,
          ),
          Expanded(
            child: PendingProductsItems(
              expeditionControlCode: expeditionControlCode,
            ),
          ),
        ],
      ),
    );
  }
}
