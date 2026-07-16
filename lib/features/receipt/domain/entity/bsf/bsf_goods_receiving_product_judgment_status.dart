enum BsfGoodsReceivingProductJudgmentStatus {
  withoutJudge(0, 'Sem julgamento'),
  accept(1, 'Aceito'),
  devolveAll(2, 'Devolver tudo'),
  devolveExcess(3, 'Devolver excesso');

  final int value;
  final String label;

  const BsfGoodsReceivingProductJudgmentStatus(this.value, this.label);

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
