enum SaleRequestErrorType {
  discount(1),
  lucrativity(2);

  final int code;
  const SaleRequestErrorType(this.code);

  factory SaleRequestErrorType.fromCode(int code) {
    return SaleRequestErrorType.values.firstWhere((e) => e.code == code);
  }
}
