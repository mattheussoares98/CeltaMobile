import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class LotItems extends ConsumerStatefulWidget {
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final int enterpriseCode;

  const LotItems({
    super.key,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.enterpriseCode,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LotItemsState();
}

class _LotItemsState extends ConsumerState<LotItems> {
  final formKey = GlobalKey<FormState>();

  void changeSelectedIndex(int? index, ProductLotInfoEntity item) {
    ref
        .read(selectedLotIndexStateControllerProvider.notifier)
        .updateIndex(index);

    widget.quantityController.text = item.quantity
        .toDouble()
        .toString()
        .toBrazilianNumber(3, true);

    widget.quantityFocusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.quantityFocusNode.requestFocus();
      widget.quantityController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.quantityController.text.length,
      );
    });
  }

  void onSubmit(ProductLotInfoEntity item) {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    ref
        .read(lotStateControllerProvider(widget.enterpriseCode).notifier)
        .addItem(
          product: item.product,
          quantity: widget.quantityController.text.toDouble()!,
          selectedDestinyStock: item.selectedDestinyStock,
          selectedJustification: item.selectedJustification,
          selectedOriginStock: item.selectedOriginStock,
        );

    ref
        .read(selectedLotIndexStateControllerProvider.notifier)
        .updateIndex(null);
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(
      lotStateControllerProvider(widget.enterpriseCode).select((s) => s.value),
    );
    return ResponsiveListFlow(
      isSliver: true,
      itemCount: products?.length ?? 0,
      itemBuilder: (_, index) {
        final item = products![index];

        final packingCode = item.product.ProductPackingCode;
        final destinyCode = item.selectedDestinyStock.CodigoInterno_TipoEstoque;
        final originCode = item.selectedOriginStock.CodigoInterno_TipoEstoque;
        final justificationCode =
            item.selectedJustification.CodigoInterno_JustMov;

        return _LotItem(
          key: ValueKey(
            '$packingCode-$destinyCode-$originCode-$justificationCode',
          ),
          index: index,
          quantityController: widget.quantityController,
          quantityFocusNode: widget.quantityFocusNode,
          enterpriseCode: widget.enterpriseCode,
          onSubmit: onSubmit,
          changeSelectedIndex: changeSelectedIndex,
          formKey: formKey,
        );
      },
    );
  }
}

class _LotItem extends ConsumerWidget {
  final int index;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final int enterpriseCode;
  final GlobalKey<FormState> formKey;
  final void Function(int? index, ProductLotInfoEntity item)
  changeSelectedIndex;
  final void Function(ProductLotInfoEntity item) onSubmit;
  const _LotItem({
    super.key,
    required this.index,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.enterpriseCode,
    required this.onSubmit,
    required this.changeSelectedIndex,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(
      lotStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.elementAtOrNull(index)),
    );

    if (item == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final isLastItem = ref.watch(
      lotStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value!.length == index + 1),
    );

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.only(bottom: isLastItem ? Sizes.p16 : 0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: isIOS ? null : () => changeSelectedIndex(index, item),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameAndJustification(item: item),
                          OriginAndDestinyWithQuantities(item: item),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: EditAndRemoveIconButtons(
                        item: item,
                        onTapEdit: () => changeSelectedIndex(index, item),
                        enterpriseCode: enterpriseCode,
                        index: index,
                      ),
                    ),
                  ],
                ),
              ),
              UpdateQuantityField(
                index: index,
                formKey: formKey,
                quantityController: quantityController,
                quantityFocusNode: quantityFocusNode,
                item: item,
                onSubmit: () => onSubmit(item),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
