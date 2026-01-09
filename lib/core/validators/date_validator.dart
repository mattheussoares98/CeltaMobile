import 'package:intl/intl.dart';

import '../../localization/string_hardcoded.dart';
import 'validators.dart';

class DateValidator implements StringValidator {
  final DateTime minimumDate;
  final DateTime maximumDate;
  final bool? allowEmptyDate;

  DateValidator({
    required this.minimumDate,
    required this.maximumDate,
    this.allowEmptyDate,
  });
  @override
  String get errorMessage => _errorMessage.hardcoded;
  String _errorMessage = '';

  // A list of all the date formats we want to accept
  final List<DateFormat> _acceptedFormats = [
    DateFormat('dd/MM/yyyy'), // Brazilian format
    // DateFormat('MM/dd/yyyy'), // American format
    // DateFormat('yyyy-MM-dd'), // ISO format
  ];

  @override
  bool isValid(String? value) {
    if (allowEmptyDate == true && (value == null || value.isEmpty)) {
      return true;
    } else if (value == null || value.isEmpty) {
      return false;
    }

    DateTime? parsedDate;

    // Loop through each of our accepted formats
    for (final format in _acceptedFormats) {
      try {
        // The 'true' parameter enables UTC parsing for consistency.
        // .parseStrict() will throw an error if the format doesn't match exactly.
        parsedDate = format.parseStrict(value, true);
        // If we get here, parsing was successful, so the date is valid.
        break;
      } catch (e) {
        // If parsing fails, just ignore the error and try the next format.
        continue;
      }
    }
    if (parsedDate == null) {
      _errorMessage = 'Data inválida'.hardcoded;
      return false;
    }

    final normalizedParsedDate = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
    );
    final normalizedStartDate = DateTime(
      minimumDate.year,
      minimumDate.month,
      minimumDate.day,
    );
    final normalizedEndDate = DateTime(
      maximumDate.year,
      maximumDate.month,
      maximumDate.day,
    );

    if (normalizedParsedDate.isBefore(normalizedStartDate) ||
        normalizedParsedDate.isAfter(normalizedEndDate)) {
      final formatter = DateFormat('dd/MM/yyyy');
      _errorMessage =
          'Período inválido. ${formatter.format(minimumDate)} ~ ${formatter.format(maximumDate)}'
              .hardcoded;
      return false;
    }

    return true;
  }
}
