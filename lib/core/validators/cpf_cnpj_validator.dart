import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/core/validators/validators.dart';

class CpfCnpjValidator implements StringValidator {
  CpfCnpjValidator({AppLocalizations? translations})
    : translations = translations ?? defaultLocalizations;

  final AppLocalizations translations;

  @override
  String get errorMessage => _errorMessage;
  String _errorMessage = '';

  @override
  bool isValid(String? value) {
    if (value == null || value.isEmpty) {
      _errorMessage = translations.requiredField;
      return false;
    } else if (int.tryParse(value) == null) {
      _errorMessage = translations.digitsOnly;
      return false;
    } else if (value.length < 11) {
      _errorMessage = translations.fieldTooShort;
      return false;
    } else if (value.length == 11) {
      bool cpfIsValid = CPFValidator.isValid(value);

      _errorMessage = cpfIsValid ? '' : translations.invalidCpf;
      return cpfIsValid;
    } else {
      bool cnpjIsValid = CNPJValidator.isValid(value);

      _errorMessage = cnpjIsValid ? '' : translations.invalidCnpj;
      return cnpjIsValid;
    }
  }
}
