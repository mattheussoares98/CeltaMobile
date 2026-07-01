// lib/features/process_authorization/domain/entities/bsf_authorization_process_judgement_type.dart
enum BSFAuthorizationProcessJudgementType {
  anyUserCanAuthorize(1, 'Qualquer usuário pode autorizar'),
  allUsersShouldAuthorize(2, 'Todos os usuários devem autorizar'),
  closedProcess(3, 'Processo encerrado'),
  definedForTheDefendantHandler(4, 'Definido para o responsável');

  final int value;
  final String label;
  const BSFAuthorizationProcessJudgementType(this.value, this.label);

  factory BSFAuthorizationProcessJudgementType.fromValue(int? value) {
    return BSFAuthorizationProcessJudgementType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BSFAuthorizationProcessJudgementType.anyUserCanAuthorize,
    );
  }
}
