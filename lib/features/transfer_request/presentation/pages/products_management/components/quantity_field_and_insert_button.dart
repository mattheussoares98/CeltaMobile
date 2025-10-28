import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class QuantityFieldAndInsertButton extends ConsumerStatefulWidget {
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final ProductEntity product;
  final int requestTypeCode;
  final int enterpriseOriginCode;
  final int enterpriseDestinyCode;

  const QuantityFieldAndInsertButton({
    super.key,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.product,
    required this.requestTypeCode,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuantityFieldAndInsertButtonState();
}

class _QuantityFieldAndInsertButtonState
    extends ConsumerState<QuantityFieldAndInsertButton> {
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
  }

  void insertProduct() {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    ref
        .read(
          pendingTransferRequestStateControllerProvider(
            DraftKey(
              requestTypeCode: widget.requestTypeCode,
              enterpriseOrigin: widget.enterpriseOriginCode,
              enterpriseDestinyCode: widget.enterpriseDestinyCode,
            ),
          ).notifier,
        )
        .addItem(
          TransferRequestProductItemEntity(
            product: widget.product,
            quantity: widget.quantityController.text.toDouble() ?? 0,
            value: widget
                .product
                .Value, //TODO enable to change the price when the sale request allows
          ),
        );

    widget.quantityController.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Form(
      key: formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DefaultTextFormField(
              controller: widget.quantityController,
              focusNode: widget.quantityFocusNode,
              labelText: 'Quantidade'.hardcoded,
              hintText: 'Quantidade'.hardcoded,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) => insertProduct(),
              maxLength: 13,
              onTap: () {
                widget.quantityController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: widget.quantityController.text.length,
                );
              },
              validator: FormValidators.compose([
                NonEmptyValidator(),
                NumberValidator(allowDecimal: true),
              ]),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          gapW8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: widget.quantityController,
                    builder: (context, value, child) {
                      final quantity = value.text.toDouble() ?? 0;
                      final total = widget.product.Value * quantity;

                      return TitleAndSubTitle(
                        title: 'Total'.hardcoded,
                        subTitle: total.toString().toBrazilianNumber(),
                        subTitleIsPrice: true,
                      );
                    },
                  ),
                ),
                PrimaryButton(
                  text: 'Adicionar'.hardcoded,
                  onPressed: () => insertProduct(),
                  icon: Icon(
                    isIOS ? CupertinoIcons.shopping_cart : Icons.shopping_cart,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
