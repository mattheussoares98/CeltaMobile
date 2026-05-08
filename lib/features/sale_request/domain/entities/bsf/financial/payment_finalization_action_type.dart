enum PaymentFinalizationActionType {
  notDefined(0),
  money(1),
  ticket(2),
  creditCard(3),
  debitCard(4),
  check(5),
  covenant(7),
  purchaseVale(8),
  portion(9),
  devolutionCredit(10),
  financialCustomerCredit(11),
  fidelityCredit(12),
  correspondentBanking(13),
  pix(14);

  final int value;
  const PaymentFinalizationActionType(this.value);

  factory PaymentFinalizationActionType.fromValue(int? value) {
    if (value == null) return PaymentFinalizationActionType.notDefined;
    return PaymentFinalizationActionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentFinalizationActionType.notDefined,
    );
  }
}
