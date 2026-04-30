enum PracticedPriceType {
  manual('Manual'),
  notDefined('Não definido'),
  retail('Varejo'),
  whole('Atacado');

  final String name;
  const PracticedPriceType(this.name);
}
