import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../controllers/controllers.dart';

class BirthDateField extends ConsumerWidget {
  final TextEditingController birthDateController;
  final FocusNode birthDateFocusNode;
  const BirthDateField({
    required this.birthDateController,
    required this.birthDateFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final minimumDate = DateTime(now.year - 100);
    final maximumDate = DateTime(now.year - 5);

    final customer = ref.watch(customerStateControllerProvider).value;

    return DefaultTextFormField(
      controller: birthDateController,
      maxLength: 10,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.datetime,
      focusNode: birthDateFocusNode,
      hintText: 'Nascimento'.hardcoded,
      labelText: 'Nascimento'.hardcoded,
      inputFormatters: [DateInputFormatter()],
      suffixIcon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () async {
              final newDate = await GetNewDate.get(
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                currentSelectedDate: customer?.DateOfBirth,
                context: context,
                insertHoursAndMinutes: false,
              );

              if (newDate != null) {
                final day = newDate.day.toString().padLeft(2, '0');
                final month = newDate.month.toString().padLeft(2, '0');
                final year = newDate.year.toString().padLeft(4, '0');
                birthDateController.text = '$day/$month/$year';
              }
            },
            icon: Icon(
              Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoIcons.calendar
                  : Icons.calendar_month,
            ),
          ),
        ],
      ),
      validator: FormValidators.compose([
        DateValidator(minimumDate: minimumDate, maximumDate: maximumDate),
      ]),
    );
  }
}
