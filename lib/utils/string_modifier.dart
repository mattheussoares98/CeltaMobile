extension StringModifier on String {
  String toBrazilianNumber([
    int decimalHouses = 2,
    bool showDecimalUntilLastNumber = false,
  ]) {
    final value = double.tryParse(this.replaceAll(',', '.'));
    if (value == null) {
      return this;
    }

    if (showDecimalUntilLastNumber) {
      if (value % 1 == 0) {
        return value.toInt().toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        );
      }

      List<String> parts = value.toString().split('.');

      parts[0] = parts[0].replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => '.',
      );

      return parts.join(',');
    }

    String formatted = value.toStringAsFixed(decimalHouses);
    List<String> parts = formatted.split('.');
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
}
