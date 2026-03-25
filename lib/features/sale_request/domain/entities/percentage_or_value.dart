enum PercentageOrValue {
  percentage('%', 1),
  value('R\$', 2);

  final String symbol;
  final int code;
  const PercentageOrValue(this.symbol, this.code);
}
