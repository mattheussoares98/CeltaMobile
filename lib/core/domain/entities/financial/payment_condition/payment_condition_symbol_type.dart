enum PaymentConditionSymbolType {
  none(0),
  dd(1),
  dfd(2),
  dfm(3),
  dfq(4),
  dfs(5),
  ddl(6),
  dv(7),
  du(8),
  dufs(9),
  dufm(10),
  dufd(11),
  dufq(12),
  ids(13),
  fds(14),
  im(15),
  fm(16);

  final int value;
  const PaymentConditionSymbolType(this.value);

  factory PaymentConditionSymbolType.fromValue(int? value) {
    if (value == null) return PaymentConditionSymbolType.none;
    return PaymentConditionSymbolType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentConditionSymbolType.none,
    );
  }
}
