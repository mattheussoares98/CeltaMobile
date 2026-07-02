// lib/features/process_authorization/domain/entities/bsf_authorization_process_judgement_status.dart
enum BSFProcessAuthorizationJudgementStatus {
  awaiting(1, 'Aguardando autorização'),
  notAuthorized(2, 'Não autorizado'),
  authorized(3, 'Autorizado');

  final int value;
  final String label;
  const BSFProcessAuthorizationJudgementStatus(this.value, this.label);

  factory BSFProcessAuthorizationJudgementStatus.fromValue(int? value) {
    return BSFProcessAuthorizationJudgementStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BSFProcessAuthorizationJudgementStatus.awaiting,
    );
  }
}
