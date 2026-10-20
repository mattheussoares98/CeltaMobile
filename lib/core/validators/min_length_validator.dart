import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/core/validators/validators.dart';

class MinLengthValidator implements StringValidator {
  final int minLength;

  MinLengthValidator(this.minLength, {AppLocalizations? translations})
    : translations = translations ?? defaultLocalizations;

  final AppLocalizations translations;

  @override
  String get errorMessage => translations.minimumLength(minLength);

  @override
  bool isValid(String? value) {
    return value != null && value.length >= minLength;
  }
}
