import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../controllers/controllers.dart';
import 'products.dart';

class ProductsConferencePage extends ConsumerStatefulWidget {
  final int expeditionControlCode;
  final int stepCode;
  final EnterpriseEntity? selectedEnterprise;
  final String documentNumber;
  final int enterpriseCode;
  const ProductsConferencePage({
    super.key,
    required this.expeditionControlCode,
    required this.stepCode,
    required this.selectedEnterprise,
    required this.documentNumber,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsConferencePageState();
}

class _ProductsConferencePageState
    extends ConsumerState<ProductsConferencePage> {
  final searchValueController = TextEditingController();
  final focusNode = FocusNode();
  int currentIndex = 0;

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingProductsAsync = ref.watch(
      expeditionConferenceControllerProvider(
        widget.expeditionControlCode,
        widget.selectedEnterprise?.name ?? '',
      ),
    );

    final searchProductsAsync = ref.watch(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.goodsReceiving, //TODO change to module
        widget.selectedEnterprise?.name ?? '',
      ),
    );

    ref.listen(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.goodsReceiving, //TODO change to module
        widget.selectedEnterprise?.name ?? '',
      ),
      (p, n) {
        n.showSnackbarOnError(
          context,
          previous: p,
          message: 'Houve um problema para pesquisar o produto. Tente novamente'
              .hardcoded,
        );

        n.doOnSuccess(p, () {
          if (n.hasValue != true) {
            return;
          }
          if (n.value != null && n.value!.length == 1) {
            ref
                .read(
                  expeditionConferenceControllerProvider(
                    widget.expeditionControlCode,
                    widget.selectedEnterprise?.name ?? '',
                  ).notifier,
                )
                .scanProduct(n.value!.first.ProductPackingCode);

            Future.delayed(Duration(milliseconds: 100), () {
              focusNode.requestFocus();
            });
          } else {
            //TODO show modal page to select the correct product to count
            debugPrint(
              'show modal page to select the correct product to count',
            );
          }
          searchValueController.clear();
        });
      },
    );

    void onRefresh() {
      ref.invalidate(
        expeditionConferenceControllerProvider(
          widget.expeditionControlCode,
          widget.selectedEnterprise?.name ?? '',
        ),
      );
    }

    final pages = [
      PendingProductsPage(
        expeditionControlCode: widget.expeditionControlCode,
        focusNode: focusNode,
        searchValueController: searchValueController,
        selectedEnterprise: widget.selectedEnterprise,
        documentNumber: widget.documentNumber,
        enterpriseCode: widget.enterpriseCode,
        pendingProductsAsync: pendingProductsAsync,
        onRefresh: onRefresh,
        searchProductsAsync: searchProductsAsync,
      ),
      ConferedProductsPage(
        onRefresh: onRefresh,
        pendingProductsAsync: pendingProductsAsync,
      ),
    ];
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Pendentes'.hardcoded,
            icon: BadgeIcon(
              badge: null, //TODO change to a widget param
              cupertinoIcon: CupertinoIcons.exclamationmark_triangle,
              materialIcon: Icons.error,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Conferidos'.hardcoded,
            icon: BadgeIcon(
              badge: null,
              cupertinoIcon: CupertinoIcons.checkmark_seal,
              materialIcon: Icons.verified_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
