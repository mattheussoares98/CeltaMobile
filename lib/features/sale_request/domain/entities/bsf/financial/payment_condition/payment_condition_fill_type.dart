enum PaymentConditionFillType {
  allowSprainOfPortions(1),
  allowSprainPercentageOfPortions(2),
  allowSprainValuesOfPortions(3),
  allowDateOfPortions(4),
  allowDatePercentageOfPortions(5),
  allowDateValuesOfPortions(6),
  allowDaysQuantityIntervalOfPortions(7),
  allowDaysAndWeekDayOfPortion(8),
  allowPaymentDayAndQuantityOfPortions(9),
  allowPeriodAndFixedDayOfPortion(10);

  final int value;
  const PaymentConditionFillType(this.value);

  factory PaymentConditionFillType.fromValue(int? value) {
    if (value == null) return PaymentConditionFillType.allowSprainOfPortions;
    return PaymentConditionFillType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentConditionFillType.allowSprainOfPortions,
    );
  }
}
