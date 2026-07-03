// lib/features/process_authorization/domain/entities/bsf_authorization_process_judgement_type.dart
enum BSFProcessAuthorizationJudgementType {
  anyUserCanAuthorize(1, 'Qualquer usuário pode autorizar'),
  allUsersShouldAuthorize(2, 'Todos os usuários devem autorizar'),
  closedProcess(3, 'Processo encerrado'),
  definedForTheDefendantHandler(4, 'Definido para o responsável');

  final int value;
  final String label;
  const BSFProcessAuthorizationJudgementType(this.value, this.label);

  factory BSFProcessAuthorizationJudgementType.fromValue(int? value) {
    return BSFProcessAuthorizationJudgementType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BSFProcessAuthorizationJudgementType.anyUserCanAuthorize,
    );
  }
}
