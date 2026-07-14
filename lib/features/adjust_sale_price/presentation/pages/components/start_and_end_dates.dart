import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final enableEndDate = ref.watch(
      uIStateControllerProvider(
        plu,
      ).select((s) => s.value?.selectedPriceType == PriceType.offer),
    );

    void changeStartDate(DateTime? date) {
      if (selectedEndDate != null &&
          date != null &&
          selectedEndDate.isBefore(date)) {
        showToastMessage(
          'A data de início precisa ser anterior a data de término'.hardcoded,
          type: ToastType.error,
        );
      } else {
        ref
            .read(uIStateControllerProvider(plu).notifier)
            .updateValues(selectedStartDate: date);
      }
    }

    void changeEndDate(DateTime? date) {
      if (selectedStartDate != null &&
          date != null &&
          selectedStartDate.isAfter(date)) {
        showToastMessage(
          'A data de término precisa ser após a data de início'.hardcoded,
          type: ToastType.error,
        );
      } else {
        ref
            .read(uIStateControllerProvider(plu).notifier)
            .updateValues(selectedEndDate: date, isChangingEndDate: true);
      }
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
              enabled: enableEndDate,
              title: 'Término ',
              isEndDate: true,
              currentSelectedDate: selectedEndDate,
              onDateChanged: changeEndDate,
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

    void updateDate() async {
      final selectedDate = await GetNewDate.get(
        context: context,
        currentSelectedDate: currentSelectedDate,
        minimumDate: now,
        maximumDate: now.add(Duration(days: isEndDate ? (365 * 5) : 365)),
      );
      if (selectedDate != null) {
        onDateChanged(selectedDate);
      }
    }

    return RepaintBoundary(
      child: InkWell(
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
                  icon: PlatformIcon(
                    cupertinoIcon: CupertinoIcons.calendar_badge_plus,
                    materialIcon: Icons.calendar_month,
                    color: enabled ? null : context.theme.disabledColor,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: BaseText.bodyMedium(
                    currentSelectedDate == null && isEndDate
                        ? "Não definido".hardcoded
                        : (currentSelectedDate ?? now).formatDate(
                            DateFormatType.ddMMyyyyHHmm,
                          ),
                    textAlign: TextAlign.center,
                    color: enabled ? null : context.theme.disabledColor,
                  ),
                ),
                if (isEndDate && currentSelectedDate != null)
                  IconButton(
                    onPressed: () => onDateChanged(null),
                    icon: const PlatformIcon(
                      cupertinoIcon: CupertinoIcons.clear,
                      materialIcon: Icons.clear,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
