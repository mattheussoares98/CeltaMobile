import 'package:intl/intl.dart';

extension StringModifier on String {
  String toBrazilianNumber([
    int decimalHouses = 2,
    bool showDecimalUntilLastNumber = false,
  ]) {
    final value = double.tryParse(this.replaceAll(',', '.'));
    if (value == null) {
      return this;
    }

    String formatted = value.toStringAsFixed(decimalHouses);

    if (showDecimalUntilLastNumber && formatted.contains('.')) {
      formatted = formatted
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }

    final parts = formatted.split('.');
    parts[0] = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return parts.join(',');
  }

  String addBrazilianCoin() {
    return "R\$ $this";
  }

  String removeWhiteSpaces() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  double? toDouble() {
    String string = replaceAll(RegExp(r','), '.');
    final quantidadeDePontos = '.'.allMatches(string).length;

    quantidadeDePontos.toString();
    if (quantidadeDePontos > 1) {
      for (var x = 1; x < quantidadeDePontos; x++) {
        if (x < quantidadeDePontos) {
          string = string.replaceFirst(RegExp(r'\.'), '');
        }
      }
    }

    return double.tryParse(string);
  }

  int? toInt([bool removePoints = false]) {
    if (removePoints) {
      return int.tryParse(
        replaceAll(RegExp(r','), '').replaceAll(RegExp(r'\.'), ''),
      );
    } else {
      return int.tryParse(this);
    }
  }

  String removeBreakLines() {
    String newValue = this;
    newValue = newValue.replaceAll(RegExp(r'\\r\\'), '');
    newValue = newValue.replaceAll(RegExp(r'\\n'), '');
    newValue = newValue.replaceAll(RegExp(r'\\'), '');

    return newValue;
  }

  String? formattedPacking() {
    final firstDigitMatch = RegExp(r'\d').firstMatch(this);

    if (firstDigitMatch == null) {
      return this;
    }

    final index = firstDigitMatch.start;
    final textPart = this.substring(0, index);
    var numberPart = this.substring(index);

    if (numberPart.contains('.')) {
      while (numberPart.endsWith('0')) {
        numberPart = numberPart.substring(0, numberPart.length - 1);
      }

      if (numberPart.endsWith('.')) {
        numberPart = numberPart.substring(0, numberPart.length - 1);
      }
    }

    return '$textPart$numberPart'.replaceAll(RegExp(r'\.'), ',');
  }

  String removeAccents() {
    const withDiacritics =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const withoutDiacritics =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    String str = this;
    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }

    // After replacing known characters, we also remove any
    // remaining non-ASCII characters that the printer can't handle.
    str = str.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

    return str;
  }

  DateTime? toDateTime({bool includeTime = false}) {
    try {
      final List<String> sections = includeTime ? split(' ') : [this];
      final List<String> dateParts = sections[0].split('/');

      if (dateParts.length == 3) {
        String isoString = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';

        if (includeTime && sections.length > 1) {
          isoString += ' ${sections[1]}';
        }

        return DateTime.parse(isoString);
      } else if (dateParts.length == 2) {
        final formats = [DateFormat('MM/yyyy'), DateFormat('MM/yy')];

        for (final format in formats) {
          try {
            return format.parseStrict(sections[0]);
          } catch (_) {
            continue;
          }
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  String toMaskedCnpjCpf() {
    // Strip non-digits to handle both formatted and raw values
    final digits = replaceAll(RegExp(r'\D'), '');

    if (digits.length == 11) {
      // CPF Standard Mask: 123.***.***-00
      final first = digits.substring(0, 3);
      final last = digits.substring(9);
      return '$first.***.***-$last';
    } else if (digits.length == 14) {
      // CNPJ Standard Mask: 12.***.***/****-99
      final first = digits.substring(0, 2);
      final last = digits.substring(12);
      return '$first.***.***/****-$last';
    } else {
      return this;
    }
  }
}
