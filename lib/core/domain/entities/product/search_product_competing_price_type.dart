enum SearchProductCompetingPriceType {
  all(0, 'Todos'),
  informedPrices(1, 'Já informados'),
  notInformedPrices(2, 'Não informados');

  final int code;
  final String name;

  const SearchProductCompetingPriceType(this.code, this.name);
}
