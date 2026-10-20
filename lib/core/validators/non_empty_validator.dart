import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/core/validators/validators.dart';

class NonEmptyValidator implements StringValidator {
  const NonEmptyValidator({String? errorMessage})
    : _errorMessage = errorMessage;

  final String? _errorMessage;

  @override
  String get errorMessage => _errorMessage ?? 'Campo obrigatório'.hardcoded;

  @override
  bool isValid(String? value) {
    return value?.isNotEmpty ?? false;
  }
}
