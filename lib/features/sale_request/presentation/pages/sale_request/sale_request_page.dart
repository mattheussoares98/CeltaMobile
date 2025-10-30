import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../enterprise_manager/domain/entities/entities.dart';
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
  bool requestTypeAllowChangePrice = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(
              requestTypeStateControllerProvider(Modules.saleRequest).future,
            )
            .then((requests) {
              int? requestIndex = requests?.indexWhere(
                (e) => e.Code == widget.requestCode,
              );
              if (requestIndex != null && requestIndex != -1) {
                setState(() {
                  requestTypeAllowChangePrice =
                      requests![requestIndex].AllowAlterCostOrSalePrice == true;
                });
              }
            });
      }
    });
  }

  final appBarTitles = [
    'Inserir produtos'.hardcoded,
    'Cliente'.hardcoded,
    'Carrinho'.hardcoded,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

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
            quantity: null, //TODO fix
            materialIcon: Icons.shopping_cart,
            cupertinoIcon: CupertinoIcons.shopping_cart,
            isSelected: false,
            offset: const Offset(3, -3),
            subtitle: Text(
              'R\$ 0,00'.hardcoded,
              style: TextStyle(fontSize: 9),
            ), //TODO fix
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          InsertProductsPage(
            enterpriseCode: widget.enterpriseCode,
            requestTypeAllowChangePrice: requestTypeAllowChangePrice,
          ),
          CustomerPage(),
          CartPage(),
        ],
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
              quantity: null, //TODO fix
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
