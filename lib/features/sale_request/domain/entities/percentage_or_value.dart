enum PercentageOrValue {
  percentage('%', 'Porcentagem', 1),
  reais('R\$', 'Reais', 2);

  final String symbol;
  final String name;
  final int code;

  const PercentageOrValue(this.symbol, this.name, this.code);
}
