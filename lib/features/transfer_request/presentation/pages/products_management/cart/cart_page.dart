import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class CartPage extends ConsumerStatefulWidget {
  final DraftKey draftKey;
  final bool requestTypeAllowChangePrice;
  const CartPage({
    super.key,
    required this.draftKey,
    required this.requestTypeAllowChangePrice,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final priceController = TextEditingController();
  final priceFocusNode = FocusNode();
  int? selectedIndex;

  @override
  void dispose() {
    super.dispose();
    quantityController.dispose();
    quantityFocusNode.dispose();
    priceController.dispose();
    priceFocusNode.dispose();
  }

  void changeSelectedIndex(int? index, TransferRequestProductItemEntity item) {
    if (selectedIndex == index || index == null) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
      quantityController.text = item.quantity
          .toString()
          .toBrazilianNumber()
          .replaceAll(RegExp(r'\.'), '');
      if (widget.requestTypeAllowChangePrice) {
        priceController.text = item.value
            .toString()
            .toBrazilianNumber()
            .replaceAll(RegExp(r'\.'), '');
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
        quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: quantityController.text.length,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastSavedAsync = ref.watch(lastSavedNumberStateControllerProvider);
    final pendingAsync = ref.watch(
      cartProductsStateControllerProvider(widget.draftKey),
    );
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Column(
        children: [
          if (pendingAsync.value == null || pendingAsync.value!.isEmpty) ...[
            Expanded(
              child: Center(
                child: Text(
                  'Nenhum produto adicionado ao carrinho'.hardcoded,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ] else
            Expanded(
              child: CustomScrollView(
                slivers: [
                  if (lastSavedAsync.value != null)
                    LastSavedNumber(number: lastSavedAsync.value!),
                  AsyncValueSliverWidget(
                    value: pendingAsync,
                    tryAgain: () => ref.invalidate(
                      cartProductsStateControllerProvider(widget.draftKey),
                    ),
                    data: (items) {
                      return ResponsiveListFlow(
                        isSliver: true,
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final item = items[index];

                          return ProductItem(
                            item: item,
                            index: index,
                            changeSelectedIndex: (index) =>
                                changeSelectedIndex(index, item),
                            draftKey: widget.draftKey,
                            selectedIndex: selectedIndex,
                            requestTypeAllowChangePrice:
                                widget.requestTypeAllowChangePrice,
                            priceController: priceController,
                            priceFocusNode: priceFocusNode,
                            quantityController: quantityController,
                            quantityFocusNode: quantityFocusNode,
                          );
                        },
                      );
                    },
                  ),
                  if ((pendingAsync.value?.length ?? 0) > 2) ...[
                    ClearCartButton(draftKey: widget.draftKey),
                    gapSliverH16,
                  ],
                ],
              ),
            ),
          Footer(draftKey: widget.draftKey),
        ],
      ),
    );
  }
}
