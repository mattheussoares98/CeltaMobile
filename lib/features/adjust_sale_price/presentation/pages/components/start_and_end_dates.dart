import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import 'components.dart';

class StartAndEndDates extends StatelessWidget {
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final void Function(DateTime newDate) onChangeStartDate;
  final void Function(DateTime newDate) onChangeEndDate;
  final bool enableEndDate;
  const StartAndEndDates({
    super.key,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onChangeStartDate,
    required this.onChangeEndDate,
    required this.enableEndDate,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _GetDateItem(
              title: 'Início ',
              enabled: true,
              isEndDate: false,
              currentSelectedDate: selectedStartDate,
              onDateChanged: (newDate) {
                if (newDate != null) {
                  onChangeStartDate(newDate);
                }
              },
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: _GetDateItem(
              enabled: enableEndDate,
              title: 'Término ',
              isEndDate: true,
              currentSelectedDate: selectedEndDate,
              onDateChanged: (newDate) {
                if (newDate != null) {
                  onChangeEndDate(newDate);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GetDateItem extends StatelessWidget {
  final void Function(DateTime? newDate) onDateChanged;
  final DateTime? currentSelectedDate;
  final String title;
  final bool isEndDate;
  final bool enabled;
  const _GetDateItem({
    required this.title,
    required this.currentSelectedDate,
    required this.onDateChanged,
    required this.isEndDate,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: TitleWidget(title: title.hardcoded, enabled: enabled),
            ),
            IconButton(
              onPressed: !enabled
                  ? null
                  : () async {
                      final selectedDate = await GetNewDate.get(
                        context: context,
                        currentSelectedDate: currentSelectedDate,
                        insertHoursAndMinutes: true,
                        minimumDate: now,
                        maximumDate: now.add(Duration(days: 365)),
                      );
                      onDateChanged(selectedDate);
                    },
              icon: Icon(
                defaultTargetPlatform == TargetPlatform.iOS
                    ? CupertinoIcons.calendar_badge_plus
                    : Icons.calendar_month,
                color: enabled ? null : theme.disabledColor,
              ),
            ),
          ],
        ),
        Text(
          currentSelectedDate == null && isEndDate
              ? "Não definido".hardcoded
              : DateFormat(
                  'dd/MM/yyyy HH:mm',
                ).format(currentSelectedDate ?? now),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: enabled ? null : theme.disabledColor,
          ),
        ),
      ],
    );
  }
}
