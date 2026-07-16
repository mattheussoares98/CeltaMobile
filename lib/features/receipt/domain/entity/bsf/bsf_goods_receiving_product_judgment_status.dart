enum BsfGoodsReceivingProductJudgmentStatus {
  withoutJudge(0),
  accept(1),
  devolveAll(2),
  devolveExcess(3);

  final int value;

  const BsfGoodsReceivingProductJudgmentStatus(this.value);

  factory BsfGoodsReceivingProductJudgmentStatus.fromValue(int? value) {
    if (value == null) {
      return BsfGoodsReceivingProductJudgmentStatus.withoutJudge;
    }
    return BsfGoodsReceivingProductJudgmentStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => BsfGoodsReceivingProductJudgmentStatus.withoutJudge,
    );
  }
}
