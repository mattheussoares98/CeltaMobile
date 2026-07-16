enum BsfGRProductJudgmentType {
  requestForFiscalNote(1, 'Solicitação para nota fiscal'),
  fiscalNoteForCounting(2, 'Nota fiscal para contagem'),
  requestForCounting(3, 'Solicitação para contagem');

  final int value;
  final String label;

  const BsfGRProductJudgmentType(this.value, this.label);

  factory BsfGRProductJudgmentType.fromValue(int? value) {
    return BsfGRProductJudgmentType.values.firstWhere(
      (element) => element.value == value,
      orElse: () => BsfGRProductJudgmentType.requestForFiscalNote,
    );
  }
}
