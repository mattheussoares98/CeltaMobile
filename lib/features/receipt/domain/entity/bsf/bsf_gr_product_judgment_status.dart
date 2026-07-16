enum BsfGRProductJudgmentStatus {
  withoutJudge(0, 'Sem julgamento'),
  accept(1, 'Aceito'),
  devolveAll(2, 'Devolver tudo'),
  devolveExcess(3, 'Devolver excesso');

  final int value;
  final String label;

  const BsfGRProductJudgmentStatus(this.value, this.label);

  factory BsfGRProductJudgmentStatus.fromValue(int? value) {
    if (value == null) {
      return BsfGRProductJudgmentStatus.withoutJudge;
    }
    return BsfGRProductJudgmentStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => BsfGRProductJudgmentStatus.withoutJudge,
    );
  }
}
