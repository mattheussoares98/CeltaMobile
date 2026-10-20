import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/search_sale_request/components/filters/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EndDateField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final FocusNode focusNode;
  final DateTime minimumDate;
  const EndDateField({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.focusNode,
    required this.minimumDate,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return BaseTextFormField(
      focusNode: focusNode,
      controller: controller,
      onFieldSubmitted: (_) => onSubmit.call(),
      labelText: context.l10n.endDate2,
      hintText: context.l10n.message00000000,
      onTap: () {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      },
      keyboardType: TextInputType.datetime,
      inputFormatters: [DateInputFormatter()],
      suffixIcon: SelectDateIconButton(
        controller: controller,
        minimumDate: minimumDate,
      ),
      validator: FormValidators.compose([
        DateValidator(
          translations: context.l10n,
          minimumDate: minimumDate,
          maximumDate: now,
          allowEmptyDate: true,
        ),
      ]),
    );
  }
}
