import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetNewDate {
  GetNewDate._();

  static Future<DateTime?> get({
    bool insertHoursAndMinutes = true,
    DateTime? currentSelectedDate,
    required DateTime minimumDate,
    required DateTime maximumDate,
    required BuildContext context,
  }) async {
    DateTime? selectedDate;

    FocusManager.instance.primaryFocus?.unfocus();

    final currentSelectedIsBeforeMinimumDate =
        currentSelectedDate?.isBefore(minimumDate) ?? true;
    final correctMinimumDate = currentSelectedIsBeforeMinimumDate
        ? minimumDate
        : currentSelectedDate!;

    final firstDate = currentSelectedIsBeforeMinimumDate
        ? correctMinimumDate
        : minimumDate;
    final initialDate = currentSelectedIsBeforeMinimumDate
        ? correctMinimumDate
        : currentSelectedDate;

    if (PlatformUtil.isCupertino) {
      selectedDate = await _showCupertinoDatePicker(
        firstDate: firstDate,
        context: context,
        maximumDate: maximumDate,
        initialDate: initialDate,
        mode: CupertinoDatePickerMode.date,
      );
    } else {
      selectedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        initialDate: initialDate,
        lastDate: maximumDate,
      );
    }

    if (selectedDate == null || !insertHoursAndMinutes) return selectedDate;

    TimeOfDay? selectedTime;

    if (PlatformUtil.isCupertino) {
      final time = await _showCupertinoDatePicker(
        firstDate: firstDate,
        context: context,
        maximumDate: maximumDate,
        initialDate: initialDate,
        mode: CupertinoDatePickerMode.time,
      );
      selectedTime = time == null
          ? null
          : TimeOfDay(hour: time.hour, minute: time.minute);
    } else {
      selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          currentSelectedDate ?? DateTime.now(),
        ),
      );
    }

    if (selectedTime == null) {
      showSnackBarMessage(
        context,
        'Horário não atualizado'.hardcoded,
        backgroundColor: Colors.red,
      );

      return null;
    }

    final finalDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (finalDateTime.isBefore(firstDate)) {
      showSnackBarMessage(
        context,
        'O horário não pode ser menor que a data mínima'.hardcoded,
        backgroundColor: Colors.red,
      );
      return null;
    }

    return finalDateTime;
  }

  static Future<DateTime?> _showCupertinoDatePicker({
    required DateTime? maximumDate,
    required DateTime? firstDate,
    required DateTime? initialDate,
    required BuildContext context,
    required CupertinoDatePickerMode mode,
  }) async {
    DateTime? tempPickedDate = firstDate;
    final theme = Theme.of(context);

    return await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: theme.primaryColor,
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(
                color: theme.primaryColor,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          child: Container(
            height: 280,
            color: Colors.white,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: Text(
                        mode == CupertinoDatePickerMode.date
                            ? 'Data'
                            : 'Horário',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: CupertinoDatePicker(
                        mode: mode,
                        initialDateTime: initialDate,
                        minimumDate: firstDate,
                        maximumDate: maximumDate,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDate) {
                          tempPickedDate = newDate;
                        },
                      ),
                    ),
                    CupertinoButton(
                      child: const Text('OK'),
                      onPressed: () => context.pop(tempPickedDate),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
