enum PercentageOrValue {
  percentage('%'),
  value('R\$');

  final String symbol;
  const PercentageOrValue(this.symbol);
}
