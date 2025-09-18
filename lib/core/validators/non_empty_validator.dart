import '../../localization/string_hardcoded.dart';
import './validators.dart';

class NonEmptyValidator implements StringValidator {
  @override
  String get errorMessage => 'Campo obrigatório'.hardcoded;

  @override
  bool isValid(String? value) {
    return value?.isNotEmpty ?? false;
  }
}
