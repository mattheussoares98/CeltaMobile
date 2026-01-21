import 'package:celta_inventario/core/validators/validators.dart';

class MockFailureValidator implements StringValidator {
  final String message;
  MockFailureValidator(this.message);

  @override
  String get errorMessage => message;

  @override
  bool isValid(String? value) => false;
}
