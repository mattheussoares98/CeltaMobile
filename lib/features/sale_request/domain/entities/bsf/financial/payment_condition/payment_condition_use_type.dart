enum PaymentConditionUseType {
  supplier(1),
  customer(2),
  enterprise(3),
  all(4),
  readSale(5),
  financial(6),
  administrator(7),
  carrier(8),
  covenant(9),
  saleDevolution(10),
  correspondentBanking(12);

  final int value;
  const PaymentConditionUseType(this.value);

  factory PaymentConditionUseType.fromValue(int? value) {
    if (value == null) return PaymentConditionUseType.all;
    return PaymentConditionUseType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentConditionUseType.all,
    );
  }
}
