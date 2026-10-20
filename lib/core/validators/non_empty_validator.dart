import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/core/validators/validators.dart';

class NonEmptyValidator implements StringValidator {
  const NonEmptyValidator({String? errorMessage, this.translations})
    : _errorMessage = errorMessage;

  final String? _errorMessage;
  final AppLocalizations? translations;

  @override
  String get errorMessage =>
      _errorMessage ?? (translations ?? defaultLocalizations).requiredField;

  @override
  bool isValid(String? value) {
    return value?.isNotEmpty ?? false;
  }
}
