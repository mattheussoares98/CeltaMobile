import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../localization/string_hardcoded.dart';
import 'validators.dart';

class CpfCnpjValidator implements StringValidator {
  @override
  String get errorMessage => _errorMessage;
  String _errorMessage = '';

  @override
  bool isValid(String? value) {
    if (value == null || value.isEmpty) {
      _errorMessage = 'Campo obrigatório'.hardcoded;
      return false;
    } else if (int.tryParse(value) == null) {
      _errorMessage = 'Digite somente números'.hardcoded;
      return false;
    } else if (value.length < 11) {
      _errorMessage = 'Campo muito curto'.hardcoded;
      return false;
    } else if (value.length == 11) {
      bool cpfIsValid = CPFValidator.isValid(value);

      _errorMessage = cpfIsValid ? '' : 'CPF inválido'.hardcoded;
      return cpfIsValid;
    } else {
      bool cnpjIsValid = CNPJValidator.isValid(value);

      _errorMessage = cnpjIsValid ? '' : 'CNPJ inválido'.hardcoded;
      return cnpjIsValid;
    }
  }
}
