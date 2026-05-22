import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/search_sale_request/components/filters/filters.dart';

class StartDateField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  const StartDateField({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final minimumDate = now.subtract(const Duration(days: 365 * 5));

    return DefaultTextFormField(
      controller: controller,
      onFieldSubmitted: (_) => onSubmit.call(),
      onTap: () {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      },
      labelText: 'Data início'.hardcoded,
      hintText: '00/00/0000'.hardcoded,
      keyboardType: TextInputType.datetime,
      inputFormatters: [DateInputFormatter()],
      suffixIcon: SelectDateIconButton(
        controller: controller,
        minimumDate: minimumDate,
      ),
      validator: FormValidators.compose([
        NonEmptyValidator(),
        DateValidator(minimumDate: minimumDate, maximumDate: now),
      ]),
    );
  }
}
