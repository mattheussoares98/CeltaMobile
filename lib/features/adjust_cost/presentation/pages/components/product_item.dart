import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
import '../../../domain/entity/entity.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

class ProductItem extends ConsumerStatefulWidget {
  const ProductItem({
    super.key,
    required this.index,
    required this.enterpriseCode,
  });

  final int index;
  final int enterpriseCode;

  @override
  ConsumerState<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends ConsumerState<ProductItem> {
  final costController = TextEditingController();
  final costFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    costController.dispose();
    costFocusNode.dispose();
    super.dispose();
  }

  void confirmAdjust(ProductEntity product) {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    ref
        .read(
          confirmAdjustCostControllerProvider(widget.enterpriseCode).notifier,
        )
        .confirm(
          AdjustCostParametersEntity(
            ReplacementCost: costController.text.toDouble()!,
            EnterpriseCode: widget.enterpriseCode,

            ProductCode: product.ProductCode!,
            PackingCode: product.ProductPackingCode!,
            LiquidCost: product.LiquidCost ?? 0,
            LastUnitValue: product.Value ?? 0,
            BaseCalcIcmsSubstUnit: 0,
            ValueOfIcmsSubstUnit: 0,
            ValueOfIcmsOwnerUnit: 0,
            FiscalBaseCalcSubstitute: 0,
            ReplacementCostReal: product.ReplacementCost ?? 0,
            LiquidCostReal: product.LiquidCost ?? 0,
            ReplacementCostFiscal: product.ReplacementCost ?? 0,
            LiquidCostFiscal: product.LiquidCost ?? 0,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(
      searchProductsStateControllerProvider(
        SearchProductKey(
          widget.enterpriseCode,
          BsRoutine.generic,
          Modules.adjustCost,
        ),
      ).select((s) => s.value![widget.index]),
    );

    final isSelected = ref.watch(
      selectedProductIndexStateControllerProvider(
        widget.enterpriseCode,
      ).select((s) => s == widget.index),
    );

    return ProductItemWidget(
      product: product,
      routine: BsRoutine.generic,
      hidePrice: true,
      hideCurrentAndSaleStocks: true,
      hideWholeInformations: true,
      showDropIcon: true,
      hideCost: true,
      isSelected: isSelected,
      onTap: () {
        costController.clear();
        ref
            .read(
              selectedProductIndexStateControllerProvider(
                widget.enterpriseCode,
              ).notifier,
            )
            .updateIndex(widget.index, annulWhenIsSame: true);
      },
      clickableBottom: Padding(
        padding: EdgeInsets.only(
          bottom: (product.EANs?.every((x) => x.isEmpty) ?? true)
              ? Sizes.p20
              : 0,
        ),
        child: TitleAndSubTitle(
          title: 'Custo de reposição'.hardcoded,
          subTitle: product.ReplacementCost,
          subTitleIsPrice: true,
          emptyMessage: 'Sem custo de reposição'.hardcoded,
        ),
      ),
      notClickableBottom: isSelected
          ? Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Form(
                    key: formKey,
                    child: UpdateCostField(
                      controller: costController,
                      focusNode: costFocusNode,
                      onSubmit: () => confirmAdjust(product),
                    ),
                  ),
                ),
                gapW16,
                Expanded(
                  child: PrimaryButton(
                    text: 'Confirmar'.hardcoded,
                    onPressed: () => confirmAdjust(product),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
