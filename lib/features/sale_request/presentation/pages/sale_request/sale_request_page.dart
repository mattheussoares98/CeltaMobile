import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../controllers/controllers.dart';
import 'sale_request.dart';

class SaleRequestPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int requestCode;
  const SaleRequestPage({
    super.key,
    required this.enterpriseCode,
    required this.requestCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SaleRequestPageState();
}

class _SaleRequestPageState extends ConsumerState<SaleRequestPage> {
  int currentIndex = 0;
  int? selectedProductIndex;

  final appBarTitles = [
    'Inserir produtos'.hardcoded,
    'Cliente'.hardcoded,
    'Carrinho'.hardcoded,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final pendingAsync = ref.watch(pendingSaleRequestStateControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text(appBarTitles[currentIndex])),
        actionsPadding: const EdgeInsets.fromLTRB(
          0,
          Sizes.p8,
          Sizes.p12,
          Sizes.p8,
        ),
        actions: [
          QuantityBadge(
            quantity: pendingAsync.value?.cart.entries.length,
            materialIcon: Icons.shopping_cart,
            cupertinoIcon: CupertinoIcons.shopping_cart,
            isSelected: false,
            offset: const Offset(3, -3),
            subtitle: Text(
              (pendingAsync.value?.cart.entries.fold<double>(0.0, (p, e) {
                        return p + e.value.TotalLiquid;
                      }).toString() ??
                      '0')
                  .toBrazilianNumber()
                  .addBrazilianCoin(),
              style: const TextStyle(fontSize: 9),
            ),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: ref.watch(
          requestTypeStateControllerProvider(Modules.saleRequest),
        ),
        tryAgain: () {
          ref.invalidate(
            requestTypeStateControllerProvider(Modules.saleRequest),
          );
        },
        data: (requests) {
          final selectedRequest = requests!.firstWhere(
            (e) => e.Code == widget.requestCode,
          );

          return IndexedStack(
            index: currentIndex,
            children: [
              InsertProductsPage(
                enterpriseCode: widget.enterpriseCode,
                selectedRequest: selectedRequest,
              ),
              const CustomerPage(),
              const CartPage(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => currentIndex = index),
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Inserir produtos'.hardcoded,
            icon: Icon(
              isIOS ? CupertinoIcons.cart_fill : Icons.add_shopping_cart,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Cliente'.hardcoded,
            icon: Icon(isIOS ? CupertinoIcons.person : Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Carrinho'.hardcoded,
            icon: QuantityBadge(
              quantity: pendingAsync.value?.cart.entries.length,
              materialIcon: Icons.shopping_cart,
              cupertinoIcon: CupertinoIcons.shopping_cart,
              isSelected: currentIndex == 2,
            ),
          ),
        ],
      ),
    );
  }
}
