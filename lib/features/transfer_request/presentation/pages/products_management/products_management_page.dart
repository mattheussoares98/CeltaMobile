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
      n.doOnSuccess(p, () {
        showSnackBarMessage(context, 'Pedido salvo com sucesso'.hardcoded);
      });
    });

    final pages = [
      InsertProductsPage(draftKey: draftKey),
      CartPage(draftKey: draftKey),
    ];
    final appBarTitles = ['Inserir produtos'.hardcoded, 'Carrinho'.hardcoded];

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final pageIndex = ref.watch(
      uiStateControllerProvider(
        requestTypeCode,
      ).select((s) => s.value?.pageIndex ?? 0),
    );

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(appBarTitles[pageIndex]),
                const LastSavedNumber(),
              ],
            ),
            actionsPadding: const EdgeInsets.fromLTRB(
              0,
              Sizes.p8,
              Sizes.p12,
              Sizes.p8,
            ),
            // leadingWidth: Sizes.p32,
            actions: [
              Consumer(
                builder: (_, ref, _) {
                  final pendingAsync = ref.watch(
                    cartProductsStateControllerProvider(draftKey),
                  );

                  final totalPrice =
                      pendingAsync.value?.fold(
                        0.0,
                        (p, e) => p + (e.value * e.quantity),
                      ) ??
                      0.0;

                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(
                            uiStateControllerProvider(requestTypeCode).notifier,
                          )
                          .updatePageIndex(1);
                    },
                    child: QuantityBadge(
                      quantity: pendingAsync.value?.length,
                      materialIcon: Icons.shopping_cart,
                      cupertinoIcon: CupertinoIcons.shopping_cart,
                      isSelected: false,
                      offset: const Offset(3, -3),
                      subtitle: Text(
                        'R\$ ${totalPrice.toStringAsFixed(2).toBrazilianNumber(2, true)}',
                        style: const TextStyle(fontSize: 9),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: IndexedStack(index: pageIndex, children: pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: pageIndex,
            onTap: ref
                .read(uiStateControllerProvider(requestTypeCode).notifier)
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
                    final pendingAsync = ref.watch(
                      cartProductsStateControllerProvider(draftKey),
                    );
                    return QuantityBadge(
                      quantity: pendingAsync.value?.length,
                      materialIcon: Icons.shopping_cart,
                      cupertinoIcon: CupertinoIcons.shopping_cart,
                      isSelected: pageIndex == 1,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        LoadingPage(
          providers: [insertTransferRequestControllerProvider(draftKey)],
        ),
      ],
    );
  }
}
