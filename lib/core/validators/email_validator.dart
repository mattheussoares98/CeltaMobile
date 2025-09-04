import '../../localization/string_hardcoded.dart';
import 'validators.dart';

class EmailValidator implements StringValidator {
  @override
  String get errorMessage => 'Por favor, insira um e-mail válido'.hardcoded;

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
