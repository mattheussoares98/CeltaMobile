enum SaleType {
  retail(1),
  whole(2),
  ecommerce(3);

  final int code;
  const SaleType(this.code);
}

extension SaleTypeExtension on SaleType {
  String get name {
    switch (this) {
      case SaleType.retail:
        return "Varejo";
      case SaleType.whole:
        return "Atacado";
      case SaleType.ecommerce:
        return "Ecommerce";
    }
  }
}
