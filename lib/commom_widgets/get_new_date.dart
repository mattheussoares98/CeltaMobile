import 'dart:io';

import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    if (Platform.isIOS) {
      selectedDate = await _showCupertinoDatePicker(
        minimumDate: minimumDate,
        context: context,
        maximumDate: maximumDate,
        currentSelectedDate: currentSelectedDate,
      );
    } else {
      selectedDate = await showDatePicker(
        context: context,
        firstDate: minimumDate,
        initialDate: currentSelectedDate,
        lastDate: maximumDate,
        locale: const Locale('pt', 'BR'),
      );
    }

    if (selectedDate == null || !insertHoursAndMinutes) return selectedDate;

    TimeOfDay? selectedTime;

    if (Platform.isIOS) {
      selectedTime = await _showCupertinoTimePicker(
        context,
        currentSelectedDate,
      );
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
  }) async {
    DateTime? tempPickedDate;

    return await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: Brightness.light,
            primaryColor: Theme.of(context).primaryColorDark,
            textTheme: CupertinoTextThemeData(
              pickerTextStyle: TextStyle(
                color: Theme.of(context).disabledColor.withAlpha(40),
                fontSize: 20,
              ),
              dateTimePickerTextStyle: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 20,
              ),
            ),
          ),
          child: Container(
            height: 300,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: currentSelectedDate,
                    minimumDate: minimumDate,
                    maximumDate: maximumDate,
                    onDateTimeChanged: (DateTime newDate) {
                      tempPickedDate = newDate;
                    },
                  ),
                ),
                CupertinoButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(tempPickedDate),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<TimeOfDay?> _showCupertinoTimePicker(
    BuildContext context,
    DateTime? currentSelectedDate,
  ) async {
    final now = DateTime.now();

    return await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: currentSelectedDate,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newDateTime) {
                    debugPrint("changed to $newDateTime");
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(
                    TimeOfDay(
                      hour: currentSelectedDate?.hour ?? now.hour,
                      minute: currentSelectedDate?.minute ?? now.minute,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
