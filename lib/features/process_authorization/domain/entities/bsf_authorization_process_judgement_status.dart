// lib/features/process_authorization/domain/entities/bsf_authorization_process_judgement_status.dart
enum BSFAuthorizationProcessJudgementStatus {
  awaiting(1, 'Aguardando autorização'),
  notAuthorized(2, 'Não autorizado'),
  authorized(3, 'Autorizado');

  final int value;
  final String label;
  const BSFAuthorizationProcessJudgementStatus(this.value, this.label);

  factory BSFAuthorizationProcessJudgementStatus.fromValue(int? value) {
    return BSFAuthorizationProcessJudgementStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BSFAuthorizationProcessJudgementStatus.awaiting,
    );
  }
}
