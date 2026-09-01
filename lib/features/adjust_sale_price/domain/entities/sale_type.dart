enum SaleType {
  retail(1, 'Varejo'),
  whole(2, 'Atacado'),
  ecommerce(3, 'E-commerce');

  final int code;
  final String name;

  const SaleType(this.code, this.name);
}
