enum SaleBlockadeDiscountType {
  none(1, 'Nenhum'),
  blockadeByOfferPrice(2, 'Bloqueio por preço de oferta'),
  blockadeByAutomaticDiscount(3, 'Bloqueio por desconto automático'),
  blockadeBySaleNegotiation(4, 'Bloqueio por negociação de venda'),
  blockadeByWholePrice(5, 'Bloqueio por preço de atacado');

  final int value;
  final String description;
  const SaleBlockadeDiscountType(this.value, this.description);

  static SaleBlockadeDiscountType? fromValue(int? value) {
    if (value == null) return null;
    for (final type in SaleBlockadeDiscountType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return null;
  }
}
