enum DiscountOrigin {
  manual(1, 'Manual'),
  saleOffer(2, 'Oferta'),
  saleNegotiation(3, 'Negociação de vendas'),
  desoneration(4, 'Desoneração'),
  salePaymentFinalization(5, 'Forma de pagamento'),
  crm(6, 'CRM');

  final int value;
  final String description;
  const DiscountOrigin(this.value, this.description);

  static DiscountOrigin? fromValue(int? value) {
    if (value == null) return null;
    for (final origin in DiscountOrigin.values) {
      if (origin.value == value) {
        return origin;
      }
    }
    return null;
  }
}
