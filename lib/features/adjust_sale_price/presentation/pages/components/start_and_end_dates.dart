import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

class StartAndEndDates extends ConsumerWidget {
  final String plu;
  const StartAndEndDates({super.key, required this.plu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStartDate = ref.watch(
      uIStateControllerProvider(plu).select((s) => s.value?.selectedStartDate),
    );
    final selectedEndDate = ref.watch(
      uIStateControllerProvider(plu).select((s) => s.value?.selectedEndDate),
    );

    final selectedPriceType = ref.watch(
      uIStateControllerProvider(plu).select((s) => s.value?.selectedPriceType),
    );

    void changeStartDate(DateTime? date) {
      ref
          .read(uIStateControllerProvider(plu).notifier)
          .updateValues(selectedStartDate: date);
    }

    void changeEndDate(DateTime? date) {
      ref
          .read(uIStateControllerProvider(plu).notifier)
          .updateValues(selectedEndDate: date);
    }

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _GetDateItem(
              title: 'Início ',
              enabled: true,
              isEndDate: false,
              currentSelectedDate: selectedStartDate,
              onDateChanged: changeStartDate,
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: _GetDateItem(
              enabled: selectedPriceType == PriceType.offer,
              title: 'Término ',
              isEndDate: true,
              currentSelectedDate: selectedEndDate,
              onDateChanged:
                  changeEndDate, //TODO throw when insert end date before start date
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

    void updateDate() async {
      final selectedDate = await GetNewDate.get(
        context: context,
        currentSelectedDate: currentSelectedDate,
        insertHoursAndMinutes: true,
        minimumDate: now,
        maximumDate: now.add(const Duration(days: 365)),
      );
      if (selectedDate != null) {
        onDateChanged(selectedDate);
      }
    }

    return InkWell(
      onTap: enabled ? updateDate : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: TitleWidget(title: title.hardcoded, enabled: enabled),
              ),
              IconButton(
                onPressed: !enabled ? null : updateDate,
                icon: Icon(
                  theme.platform == TargetPlatform.iOS
                      ? CupertinoIcons.calendar_badge_plus
                      : Icons.calendar_month,
                  color: enabled ? null : theme.disabledColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  currentSelectedDate == null && isEndDate
                      ? "Não definido".hardcoded
                      : DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(currentSelectedDate ?? now),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: enabled ? null : theme.disabledColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (isEndDate && currentSelectedDate != null)
                IconButton(
                  onPressed: () => onDateChanged(null),
                  icon: Icon(
                    theme.platform == TargetPlatform.iOS
                        ? CupertinoIcons.clear
                        : Icons.clear,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
