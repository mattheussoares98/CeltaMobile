enum CustomerSexType {
  male('Masculino', 'M'),
  female('Faminino', 'F');

  final String name;
  final String shortName;
  const CustomerSexType(this.name, this.shortName);
}
