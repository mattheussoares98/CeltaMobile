enum BsfGoodsReceivingProductJudgmentType {
  requestForFiscalNote(1, 'Solicitação para nota fiscal'),
  fiscalNoteForCounting(2, 'Nota fiscal para contagem'),
  requestForCounting(3, 'Solicitação para contagem');

  final int value;
  final String label;

  const BsfGoodsReceivingProductJudgmentType(this.value, this.label);

  factory BsfGoodsReceivingProductJudgmentType.fromValue(int? value) {
    return BsfGoodsReceivingProductJudgmentType.values.firstWhere(
      (element) => element.value == value,
      orElse: () => BsfGoodsReceivingProductJudgmentType.requestForFiscalNote,
    );
  }
}
