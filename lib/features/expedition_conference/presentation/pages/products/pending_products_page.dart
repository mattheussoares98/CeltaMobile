import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/infraestructure/infrastructure.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/features/settings/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    void searchProducts(bool searchByCamera, int? exactProductCode) async {
      focusNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 100));

      String? barcode;
      if (searchByCamera) {
        if (!context.mounted) return;
        final barcode = await BarcodeScannerService.scanBarcode(context);
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
            exactProductCode: exactProductCode,
            GetProductsJsonParams(
              searchValue: barcode ?? searchProductController.text,
              enterpriseCodes: [enterpriseCode],
            ),
          );
    }

    final isContinuousScan = ref.read(
      appSettingsStateControllerProvider.select(
        (s) => s.value?.expeditionUseContinuousScan == true,
      ),
    );

    ref.listen(expeditionConferenceControllerProvider(expeditionControlCode), (
      p,
      n,
    ) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(previousMustBeLoading: false, p, () async {
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
            searchProducts(true, null);
          });
        }
      });
    });

    return Column(
      children: [
        Consumer(
          builder: (_, ref, _) {
            return DefaultSearchProducts(
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
              searchProducts: (exactProductCode) =>
                  searchProducts(false, exactProductCode),
              searchValueController: searchProductController,
            );
          },
        ),
        Expanded(
          child: PendingProductsItems(
            expeditionControlCode: expeditionControlCode,
          ),
        ),
      ],
    );
  }
}
