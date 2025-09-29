import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/stock/stock.dart';
import '../../../../../core/validators/validators.dart';

class ConfirmAdjustStock extends ConsumerWidget {
  final ProductEntity product;
  final TransferJustificationEntity? selectedJustification;
  final StockTypeEntity? selectedStockType;
  final TextEditingController quantityController;
  final bool isLoading;
  final FocusNode quantityFocusNode;
  final int enterpriseCode;
  final GlobalKey<FormState> formKey;
  const ConfirmAdjustStock({
    super.key,
    required this.product,
    required this.selectedJustification,
    required this.selectedStockType,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.isLoading,
    required this.enterpriseCode,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> confirmAdjust() async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      await ref.read(confirmAdjustStockControllerProvider.notifier).confirm([
        AdjustStockItemEntity(
          EnterpriseCode: enterpriseCode,
          ProductCode: product.ProductCode,
          ProductPackingCode: product.ProductPackingCode,
          JustificationCode: selectedJustification!.CodigoInterno_JustMov,
          StockTypeCode: selectedStockType!.CodigoInterno_TipoEstoque!,
          StockTypeRecipientCode: null,
          IsPendingAdjust: false,
          Quantity: quantityController.text.toDouble() ?? 0,
        ),
      ]);
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DefaultTextFormField(
            controller: quantityController,
            maxLength: 14,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            focusNode: quantityFocusNode,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
            ), //TODO test in iOS
            onFieldSubmitted: (_) {
              confirmAdjust();
            },
            hintText: "Quantidade".hardcoded,
            labelText: "Quantidade".hardcoded,
            validator: FormValidators.compose([
              NonEmptyValidator(),
              NumberValidator(allowDecimal: true),
            ]),
          ),
        ),
        gapW8,
        Flexible(
          child: PrimaryButton(
            text: 'Confirmar'.hardcoded,
            onPressed: confirmAdjust,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}
