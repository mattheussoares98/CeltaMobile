import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int researchCode;
  final int concurrentCode;
  final String? researchName;
  final String? concurrentName;
  const ProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.researchCode,
    required this.concurrentCode,
    required this.researchName,
    required this.concurrentName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssociatedsPageState();
}

class _AssociatedsPageState extends ConsumerState<ProductsPage> {
  final searchValueController = TextEditingController();
  final retailController = TextEditingController();
  final retailOfferController = TextEditingController();
  final wholeController = TextEditingController();
  final wholeOfferController = TextEditingController();
  final ecommerceController = TextEditingController();
  final ecommerceOfferController = TextEditingController();
  final retailFocusNode = FocusNode();
  final retailOfferFocusNode = FocusNode();
  final wholeFocusNode = FocusNode();
  final wholeOfferFocusNode = FocusNode();
  final ecommerceFocusNode = FocusNode();
  final ecommerceOfferFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
    retailController.dispose();
    retailOfferController.dispose();
    wholeController.dispose();
    wholeOfferController.dispose();
    ecommerceController.dispose();
    ecommerceOfferController.dispose();
    retailFocusNode.dispose();
    retailOfferFocusNode.dispose();
    wholeFocusNode.dispose();
    wholeOfferFocusNode.dispose();
    ecommerceFocusNode.dispose();
    ecommerceOfferFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      searchProductsStateControllerProvider(
        SearchProductKey(
          widget.enterpriseCode,
          BsRoutine.researchOfPrice,
          Modules.competingPrices,
        ),
      ),
      (p, n) {
        n.doOnSuccess(p, () {
          searchValueController.clear();
        });
      },
    );

    ref.listen(updatePricesControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        final currentValue = ref.read(selectedItemUIControllerProvider);
        ref
            .read(selectedItemUIControllerProvider.notifier)
            .update(
              currentValue,
            ); //remove the selected index when is equal the previous
      });
      n.showAlertDialogOnError(context);
      n.showSnackbarOnSuccess(
        context,
        previous: p,
        message: 'Preços alterados com sucesso'.hardcoded,
      );
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: AppBarTitle(widget: widget),
            toolbarHeight:
                widget.researchName != null && widget.concurrentName != null
                ? 66
                : null,
          ),
          body: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              children: [
                ResponsiveScrollableWidget(
                  padding: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Filters(widget: widget),
                      SearchProductsField(
                        widget: widget,
                        searchValueController: searchValueController,
                      ),
                      gapH8,
                    ],
                  ),
                ),
                ProductsItems(
                  retailController: retailController,
                  retailOfferController: retailOfferController,
                  wholeController: wholeController,
                  wholeOfferController: wholeOfferController,
                  ecommerceController: ecommerceController,
                  ecommerceOfferController: ecommerceOfferController,
                  retailFocusNode: retailFocusNode,
                  retailOfferFocusNode: retailOfferFocusNode,
                  wholeFocusNode: wholeFocusNode,
                  wholeOfferFocusNode: wholeOfferFocusNode,
                  ecommerceFocusNode: ecommerceFocusNode,
                  ecommerceOfferFocusNode: ecommerceOfferFocusNode,
                  widget: widget,
                ),
              ],
            ),
          ),
        ),
        LoadingPage(providers: [updatePricesControllerProvider]),
      ],
    );
  }
}
