import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/core/validators/validators.dart';

class MinLengthValidator implements StringValidator {
  final int minLength;

  MinLengthValidator(this.minLength);

  @override
  String get errorMessage =>
      'Precisa ter pelo menos $minLength caracteres'.hardcoded;

  @override
  bool isValid(String? value) {
    return value != null && value.length >= minLength;
  }
}
