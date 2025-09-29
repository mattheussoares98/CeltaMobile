import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/validators/validators.dart';

class AddInLot extends ConsumerWidget {
  final ProductEntity product;
  final TransferJustificationEntity? selectedJustification;
  final StockTypeEntity? selectedStockType;
  final TextEditingController quantityController;
  final bool isLoading;
  final FocusNode quantityFocusNode;
  final int enterpriseCode;
  final GlobalKey<FormState> formKey;
  const AddInLot({
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
    Future<void> addInLot() async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      //TODO add in lot
    }

    final theme = Theme.of(context);

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
              addInLot();
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
        Expanded(
          child: PrimaryButton(
            text: 'Lote'.hardcoded,
            icon: Icon(
              theme.platform == TargetPlatform.iOS
                  ? CupertinoIcons.add
                  : Icons.add,
            ),
            onPressed: addInLot,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}
