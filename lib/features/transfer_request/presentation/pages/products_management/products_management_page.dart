import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../enterprise_manager/domain/entities/entities.dart';
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
  int currentIndex = 0;
  final searchValueController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final searchValueFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();
  int? selectedProductIndex;
  bool requestTypeAllowChangePrice = false;

  @override
  void initState() {
    super.initState();

    ref
        .read(
          requestTypeStateControllerProvider(Modules.transferRequest).future,
        )
        .then((value) {
          setState(() {
            final requestIndex = value?.indexWhere(
              (e) => e.Code == widget.requestTypeCode,
            );
            if (requestIndex == null || requestIndex == -1) {
              return;
            }

            requestTypeAllowChangePrice =
                value![requestIndex].AllowAlterCostOrSalePrice == true;
          });
        });
  }

  @override
  void dispose() {
    searchValueController.dispose();
    quantityController.dispose();
    priceController.dispose();
    searchValueFocusNode.dispose();
    priceFocusNode.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  void onTapProductItem({
    required int index,
    required ProductEntity product,
    required List<RequestTypeEntity>? requests,
    required TransferRequestProductItemEntity? transferRequestProductItem,
  }) {
    priceController.clear();

    if (product.Value == 0 && !requestTypeAllowChangePrice) {
      showSnackBarMessage(
        context,
        'O produto está com o preço zerado e o modelo de pedido selecionado não permite alterar o preço'
            .hardcoded,
        backgroundColor: Colors.red,
      );
      setState(() {
        selectedProductIndex = null;
      });
      return;
    }

    if (selectedProductIndex == index) {
      setState(() {
        selectedProductIndex = null;
      });
    } else {
      setState(() => selectedProductIndex = index);
      quantityController.text = '1';

      if (product.Value > 0 || transferRequestProductItem?.value != null) {
        priceController.text =
            transferRequestProductItem?.value.toString() ??
            product.Value.toString();
      }
      Future.delayed(Duration(milliseconds: 100), () {
        quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: quantityController.text.length,
        );
        quantityFocusNode.requestFocus();
      });
    }
  }

  void removeProductItem(
    TransferRequestProductItemEntity productItem,
    DraftKey draftKey,
  ) {
    ref
        .read(cartProductsStateControllerProvider(draftKey).notifier)
        .removeItem(productItem);
  }

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
    final insertAsync = ref.watch(
      insertTransferRequestControllerProvider(draftKey),
    );

    final pages = [
      InsertProductsPage(
        //TODO move these properties below to the own page
        enterpriseOriginCode: widget.enterpriseOriginCode,
        enterpriseDestinyCode: widget.enterpriseDestinyCode,
        requestTypeCode: widget.requestTypeCode,
        searchValueController: searchValueController,
        searchValueFocusNode: searchValueFocusNode,
        quantityController: quantityController,
        quantityFocusNode: quantityFocusNode,
        priceFocusNode: priceFocusNode,
        priceController: priceController,
        onTapProductItem: onTapProductItem,
        removeProductItem: (item) => removeProductItem(item, draftKey),
        requestTypeAllowChangePrice: requestTypeAllowChangePrice,
        selectedProductIndex: selectedProductIndex,
        changeSelectedIndex: (index) =>
            setState(() => selectedProductIndex = index),
      ),
      CartPage(
        draftKey: draftKey,
        requestTypeAllowChangePrice: requestTypeAllowChangePrice,
      ),
    ];
    final appBarTitles = ['Inserir produtos'.hardcoded, 'Carrinho'.hardcoded];

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final totalPrice =
        pendingAsync.value?.fold(0.0, (p, e) => p + (e.value * e.quantity)) ??
        0.0;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(appBarTitles[currentIndex]),
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
                offset: Offset(3, -3),
                subtitle: Text(
                  'R\$ ${totalPrice.toStringAsFixed(2).toBrazilianNumber(2, true)}',
                  style: TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
                selectedProductIndex = null;
              });
            },
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
                  isSelected: currentIndex == 1,
                ),
              ),
            ],
          ),
        ),
        if (insertAsync.isLoading) LoadingPage(),
      ],
    );
  }
}
