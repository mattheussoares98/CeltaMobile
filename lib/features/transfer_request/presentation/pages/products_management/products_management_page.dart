import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/keyboard/keyboard/keyboard.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/products_management/products_management.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductsManagementPage extends HookConsumerWidget {
  final int enterpriseOriginCode;
  final int enterpriseDestinyCode;
  final int requestTypeCode;
  const ProductsManagementPage({
    super.key,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeCode,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftKey = DraftKey(
      requestTypeCode: requestTypeCode,
      enterpriseOrigin: enterpriseOriginCode,
      enterpriseDestinyCode: enterpriseDestinyCode,
    );
    final pageIndex = useState(0);

    ref.listen(insertTransferRequestControllerProvider(draftKey), (p, n) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () {
        showToastMessage(context.l10n.orderSavedSuccessfully);
      });
    });

    final pages = [
      InsertProductsPage(draftKey: draftKey),
      CartPage(draftKey: draftKey),
    ];

    ref.observeLoading([insertTransferRequestControllerProvider(draftKey)]);

    final screenWidth = MediaQuery.sizeOf(context).width;

    return BaseScaffold(
      isScrollable: false,
      resizeToAvoidBottomInset: true,
      padding: const EdgeInsets.fromLTRB(Sizes.p8, 0, Sizes.p8, 0),
      appBar: BaseAppBar(
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (screenWidth > 250) ...[
              Row(
                children: [
                  BaseText.bodySmall(context.l10n.from),
                  Expanded(
                    child: CorrespondentEnterpriseByEnterpriseCode(
                      enterpriseCode: enterpriseOriginCode,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  BaseText.bodySmall(context.l10n.to),
                  Expanded(
                    child: CorrespondentEnterpriseByEnterpriseCode(
                      enterpriseCode: enterpriseDestinyCode,
                    ),
                  ),
                ],
              ),
            ],
            const LastSavedNumber(),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(0, Sizes.p8, Sizes.p12, 0),
        actions: [
          if (MediaQuery.sizeOf(context).width > 250)
            ClearCartButton(draftKey: draftKey),
          CartQuantityPriceBadge(
            draftKey: draftKey,
            onTap: () => pageIndex.value = 1,
          ),
        ],
      ),
      body: Consumer(
        builder: (_, ref, _) {
          return IndexedStack(index: pageIndex.value, children: pages);
        },
      ),
      floatingActionButton: Consumer(
        builder: (_, ref, _) {
          final keyboardIsOpen = ref.watch(
            keyboardVisibilityStateControllerProvider,
          );

          if (keyboardIsOpen) return const SizedBox.shrink();

          final isOnInsertPage = pageIndex.value == 0;

          if (isOnInsertPage) return const SizedBox.shrink();

          return SaveFloatingButton(draftKey: draftKey);
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (_, ref, _) {
          final productsLength = ref.watch(
            cartProductsStateControllerProvider(
              draftKey,
            ).select((s) => s.value?.length),
          );

          return BaseBottomNavigationBar(
            currentIndex: pageIndex.value,
            onTap: (index) => pageIndex.value = index,
            items: [
              BaseBottomNavigationBarItem(
                label: context.l10n.insert,
                platformIcon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.cart_badge_plus,
                  materialIcon: Icons.add_shopping_cart_outlined,
                ),
              ),
              BaseBottomNavigationBarItem(
                label: context.l10n.cart,
                badgeLabel: productsLength != null && productsLength > 0
                    ? productsLength.toString()
                    : null,
                platformIcon: const PlatformIcon(
                  materialIcon: Icons.shopping_cart,
                  cupertinoIcon: CupertinoIcons.shopping_cart,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
