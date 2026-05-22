import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/core/validators/validators.dart';

class NonEmptyValidator implements StringValidator {
  @override
  String get errorMessage => 'Campo obrigatório'.hardcoded;

  @override
  bool isValid(String? value) {
    return value?.isNotEmpty ?? false;
  }
}
