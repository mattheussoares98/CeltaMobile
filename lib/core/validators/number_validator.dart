import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/core/validators/validators.dart';

class NumberValidator implements StringValidator {
  final bool allowDecimal;
  final int? maxDecimalHouses;
  final bool needsBeGreaterThanZero;
  final bool? allowEmptyValue;

  NumberValidator({
    AppLocalizations? translations,
    required this.allowDecimal,
    this.maxDecimalHouses = 2,
    this.needsBeGreaterThanZero = true,
    this.allowEmptyValue,
  }) : translations = translations ?? defaultLocalizations;

  final AppLocalizations translations;

  String? _errorMessage;

  @override
  String get errorMessage => _errorMessage ?? '';

  @override
  bool isValid(String? value) {
    if (allowEmptyValue == true && (value == null || value.trim().isEmpty)) {
      return true;
    }

    if (value == null || value.trim().isEmpty) {
      _errorMessage = translations.requiredField;
      return false;
    }

    if (RegExp(r'[^\d,.]').hasMatch(value)) {
      _errorMessage = translations.invalidFormat;
      return false;
    }

    final separatorCount =
        value.split('.').length - 1 + value.split(',').length - 1;
    if (separatorCount > 1) {
      _errorMessage = translations.invalidFormat;
      return false;
    }

    // 1. Sanitize the input string to a universal format (e.g., '1234.56')
    // This handles both '1.234,56' (pt-BR) and '1,234.56' (en-US)
    final sanitizedValue = value
        .replaceAll(RegExp(r'[^\d,.]'), '') // Keep only digits, commas, dots
        .replaceAll(',', '.'); // Convert comma to dot

    // Remove all dots that are not the last one (to clear thousand separators)
    final normalizedValue = sanitizedValue.replaceAll(
      RegExp(r'\.(?=[^.]*\.)'),
      '',
    );

    // 2. Try to parse the normalized string
    final number = num.tryParse(normalizedValue);

    if (number == null) {
      _errorMessage = translations.invalidFormat;
      return false;
    }

    // 3. If decimals are not allowed, check if the number is an integer
    if (!allowDecimal && number != number.truncate()) {
      _errorMessage = translations.integersOnly;
      return false;
    }

    if (maxDecimalHouses != null && normalizedValue.contains('.')) {
      // Get the part of the string after the decimal point
      final decimalPart = normalizedValue.split('.').last;
      if (decimalPart.length > maxDecimalHouses!) {
        _errorMessage = translations.maxDecimalPlaces(maxDecimalHouses!);
        return false;
      }
    }

    if (needsBeGreaterThanZero && number <= 0) {
      _errorMessage = translations.greaterThanZero;
      return false;
    }

    // 4. If all checks pass, the value is valid
    _errorMessage = null;
    return true;
  }
}
