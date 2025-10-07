import 'package:intl/intl.dart';

import '../../localization/string_hardcoded.dart';
import 'validators.dart';

class DateValidator implements StringValidator {
  @override
  String get errorMessage => 'Data inválida'.hardcoded;

  // A list of all the date formats we want to accept
  final List<DateFormat> _acceptedFormats = [
    DateFormat('dd/MM/yyyy'), // Brazilian format
    // DateFormat('MM/dd/yyyy'), // American format
    // DateFormat('yyyy-MM-dd'), // ISO format
  ];

  @override
  bool isValid(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }

    // Loop through each of our accepted formats
    for (final format in _acceptedFormats) {
      try {
        // The 'true' parameter enables UTC parsing for consistency.
        // .parseStrict() will throw an error if the format doesn't match exactly.
        format.parseStrict(value, true);
        // If we get here, parsing was successful, so the date is valid.
        return true;
      } catch (e) {
        // If parsing fails, just ignore the error and try the next format.
        continue;
      }
    }

    // If the loop finishes and no format has matched, the date is invalid.
    return false;
  }
}
