import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'commom_widgets.dart';

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

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      selectedDate = await _showCupertinoDatePicker(
        minimumDate: minimumDate,
        context: context,
        maximumDate: maximumDate,
        currentSelectedDate: currentSelectedDate,
        mode: CupertinoDatePickerMode.date,
      );
    } else {
      selectedDate = await showDatePicker(
        context: context,
        firstDate: minimumDate,
        initialDate: currentSelectedDate,
        lastDate: maximumDate,
      );
    }

    if (selectedDate == null || !insertHoursAndMinutes) return selectedDate;

    TimeOfDay? selectedTime;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final time = await _showCupertinoDatePicker(
        minimumDate: minimumDate,
        context: context,
        maximumDate: maximumDate,
        currentSelectedDate: currentSelectedDate,
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

    if (finalDateTime.isBefore(minimumDate)) {
      showSnackBarMessage(
        context,
        'Horário não atualizado'.hardcoded,
        backgroundColor: Colors.red,
      );
      return null;
    }

    return finalDateTime;
  }

  static Future<DateTime?> _showCupertinoDatePicker({
    required DateTime? maximumDate,
    required DateTime? minimumDate,
    required DateTime? currentSelectedDate,
    required BuildContext context,
    required CupertinoDatePickerMode mode,
  }) async {
    DateTime? tempPickedDate = currentSelectedDate;
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
            height: 230,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: CupertinoDatePicker(
                      mode: mode,
                      initialDateTime: currentSelectedDate,
                      minimumDate: minimumDate,
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
        );
      },
    );
  }
}
