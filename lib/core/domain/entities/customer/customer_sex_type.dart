enum CustomerSexType {
  male('Masculino', 'M'),
  female('Feminino', 'F');

  final String name;
  final String shortName;
  const CustomerSexType(this.name, this.shortName);
}
