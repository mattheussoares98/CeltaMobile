enum CustomerPersonType {
  fisica('F', 'Pessoa física'),
  juridica('J', 'Pessoa jurídica');

  final String shortName;
  final String completeName;
  const CustomerPersonType(this.shortName, this.completeName);
}
