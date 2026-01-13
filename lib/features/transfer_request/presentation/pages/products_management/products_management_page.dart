import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'products_management.dart';

class ProductsManagementPage extends ConsumerStatefulWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsManagementPageState();
}

class _ProductsManagementPageState
    extends ConsumerState<ProductsManagementPage> {
  @override
  Widget build(BuildContext context) {
    final draftKey = DraftKey(
      requestTypeCode: widget.requestTypeCode,
      enterpriseOrigin: widget.enterpriseOriginCode,
      enterpriseDestinyCode: widget.enterpriseDestinyCode,
    );
    final pendingAsync = ref.watch(
      cartProductsStateControllerProvider(draftKey),
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

    final totalPrice =
        pendingAsync.value?.fold(0.0, (p, e) => p + (e.value * e.quantity)) ??
        0.0;

    final pageIndex = ref.watch(
      uiStateControllerProvider(
        widget.requestTypeCode,
      ).select((s) => s.value?.pageIndex ?? 0),
    );

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: pageIndex == 0,
          appBar: AppBar(
            title: Text(appBarTitles[pageIndex]),
            actionsPadding: const EdgeInsets.fromLTRB(
              0,
              Sizes.p8,
              Sizes.p12,
              Sizes.p8,
            ),
            actions: [
              QuantityBadge(
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
            ],
          ),
          body: IndexedStack(index: pageIndex, children: pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: pageIndex,
            onTap: ref
                .read(
                  uiStateControllerProvider(widget.requestTypeCode).notifier,
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
                icon: QuantityBadge(
                  quantity: pendingAsync.value?.length,
                  materialIcon: Icons.shopping_cart,
                  cupertinoIcon: CupertinoIcons.shopping_cart,
                  isSelected: pageIndex == 1,
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
