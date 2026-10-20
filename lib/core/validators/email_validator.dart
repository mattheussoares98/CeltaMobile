import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/core/validators/validators.dart';

class EmailValidator implements StringValidator {
  EmailValidator({AppLocalizations? translations})
    : translations = translations ?? defaultLocalizations;

  final AppLocalizations translations;

  @override
  String get errorMessage => translations.invalidEmail;

  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  bool isValid(String? value) {
    if (value != null && _emailRegex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }
}
