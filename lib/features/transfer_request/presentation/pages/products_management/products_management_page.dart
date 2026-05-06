import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
import 'products_management.dart';

class ProductsManagementPage extends ConsumerWidget {
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

    ref.listen(insertTransferRequestControllerProvider(draftKey), (p, n) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () {
        showSnackBarMessage(context, 'Pedido salvo com sucesso'.hardcoded);
      });
    });

    final pages = [
      InsertProductsPage(draftKey: draftKey),
      CartPage(draftKey: draftKey),
    ];

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    ref.observeLoading([insertTransferRequestControllerProvider(draftKey)]);

    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (screenWidth > 250) ...[
              Row(
                children: [
                  Text('De '.hardcoded, style: theme.textTheme.bodySmall),
                  Expanded(
                    child: CorrespondentEnterpriseByEnterpriseCode(
                      enterpriseCode: enterpriseOriginCode,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Para '.hardcoded, style: theme.textTheme.bodySmall),
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
        titleSpacing: 0,
        actionsPadding: const EdgeInsets.fromLTRB(0, Sizes.p8, Sizes.p12, 0),
        actions: [
          if (MediaQuery.sizeOf(context).width > 250)
            ClearCartButton(draftKey: draftKey),
          CartQuantityPriceBadge(
            requestTypeCode: requestTypeCode,
            draftKey: draftKey,
          ),
        ],
      ),
      body: Consumer(
        builder: (_, ref, _) {
          final pageIndex = ref.watch(
            uiStateControllerProvider(
              requestTypeCode,
              enterpriseOriginCode,
            ).select((s) => s.value?.pageIndex ?? 0),
          );
          return IndexedStack(index: pageIndex, children: pages);
        },
      ),
      floatingActionButton: Consumer(
        builder: (_, ref, _) {
          final pageIndex = ref.watch(
            uiStateControllerProvider(
              requestTypeCode,
              enterpriseOriginCode,
            ).select((s) => s.value?.pageIndex ?? 0),
          );
          return pageIndex == 0
              ? const SizedBox.shrink()
              : SaveFloatingButton(draftKey: draftKey);
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (_, ref, _) {
          final pageIndex = ref.watch(
            uiStateControllerProvider(
              requestTypeCode,
              enterpriseOriginCode,
            ).select((s) => s.value?.pageIndex ?? 0),
          );

          return BottomNavigationBar(
            currentIndex: pageIndex,
            onTap: ref
                .read(
                  uiStateControllerProvider(
                    requestTypeCode,
                    enterpriseOriginCode,
                  ).notifier,
                )
                .updatePageIndex,
            items: [
              BottomNavigationBarItem(
                label: 'Inserir'.hardcoded,
                icon: Icon(
                  isIOS
                      ? CupertinoIcons.cart_badge_plus
                      : Icons.add_shopping_cart_outlined,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Carrinho'.hardcoded,
                icon: Consumer(
                  builder: (_, ref, _) {
                    final productsLength = ref.watch(
                      cartProductsStateControllerProvider(
                        draftKey,
                      ).select((s) => s.value?.length),
                    );
                    return QuantityBadge(
                      quantity: productsLength,
                      platformIcon: const PlatformIcon(
                        materialIcon: Icons.shopping_cart,
                        cupertinoIcon: CupertinoIcons.shopping_cart,
                      ),
                      isSelected: pageIndex == 1,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
