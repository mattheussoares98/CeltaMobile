import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/core/validators/validators.dart';

class IpValidator implements StringValidator {
  IpValidator({AppLocalizations? translations})
    : translations = translations ?? defaultLocalizations;

  final AppLocalizations translations;

  String? _errorMessage;

  @override
  String get errorMessage => _errorMessage ?? translations.invalidIp;

  @override
  bool isValid(String? value) {
    if (value == null || value.trim().isEmpty) {
      _errorMessage = translations.invalidIp;
      return false;
    }

    // This RegExp validates an IPv4 address, checking that each of
    // the four octets is a number between 0 and 255.
    final ipRegex = RegExp(
      r'^(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.'
      r'(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.'
      r'(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.'
      r'(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$',
    );

    if (ipRegex.hasMatch(value.trim())) {
      _errorMessage = null;
      return true;
    } else {
      _errorMessage = translations.invalidIp;
      return false;
    }
  }
}
