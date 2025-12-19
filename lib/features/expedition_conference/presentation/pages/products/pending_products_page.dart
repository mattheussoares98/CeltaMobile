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
  final TextEditingController searchValueController;
  final int expeditionControlCode;
  const PendingProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.focusNode,
    required this.searchValueController,
    required this.expeditionControlCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingProductsAsync = ref.watch(
      expeditionConferenceControllerProvider(expeditionControlCode),
    );
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
          searchValueController.text = barcode;
        }
      }
      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .loadProducts(
            GetProductsJsonParams(
              searchValue: barcode ?? searchValueController.text,
              enterpriseCodes: [enterpriseCode],
            ),
          );
    }

    final isContinuousScan = ref.watch(
      appSettingsStateControllerProvider.select(
        (s) =>
            s.value?.inventoryUseContinuousScan ==
            true, //TODO change to another
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

    if (pendingProductsAsync.value?.pendingProducts == null ||
        pendingProductsAsync.value!.pendingProducts.isEmpty) {
      return EmptyProductsMessage(
        onRefreshEmptyProducts: () {
          ref.invalidate(
            expeditionConferenceControllerProvider(expeditionControlCode),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: Sizes.p4),
              child: DefaultSearchProducts(
                searchProductKey: searchProductKey,
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
                searchValueController: searchValueController,
              ),
            ),
          ),
          PendingProductsItems(expeditionControlCode: expeditionControlCode),
        ],
      ),
    );
  }
}
