import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/adjust_cost/domain/entity/entity.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      showEditIcon: true,
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
      clickableBottom: TitleAndSubTitle(
        title: 'Custo de reposição'.hardcoded,
        subTitle: product.ReplacementCost,
        subTitleIsPrice: true,
        emptyMessage: 'Sem custo de reposição'.hardcoded,
      ),
      notClickableBottom: isSelected
          ? Row(
              children: [
                Flexible(
                  flex: 2,
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
