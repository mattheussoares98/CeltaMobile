import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../utils/utils.dart';

class SelectDateIconButton extends StatelessWidget {
  final TextEditingController controller;
  final DateTime minimumDate;
  const SelectDateIconButton({
    super.key,
    required this.controller,
    required this.minimumDate,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final date = await GetNewDate.get(
          minimumDate: minimumDate,
          insertHoursAndMinutes: false,
          maximumDate: DateTime.now(),
          context: context,
          currentSelectedDate: controller.text.toDateTime(),
        );
        if (date != null) {
          controller.text = DateFormat('dd/MM/yyyy').format(date);
        }
      },
      icon: const _CalendarIcon(),
    );
  }
}

class _CalendarIcon extends StatelessWidget {
  const _CalendarIcon();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Icon(isIOS ? CupertinoIcons.calendar : Icons.date_range);
  }
}
