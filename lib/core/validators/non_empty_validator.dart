import '../../localization/string_hardcoded.dart';
import './validators.dart';

class NonEmptyValidator implements StringValidator {
  @override
  String get errorMessage => 'Esse campo não pode ser vazio'.hardcoded;

  @override
  bool isValid(String? value) {
    return value?.isNotEmpty ?? false;
  }
}
