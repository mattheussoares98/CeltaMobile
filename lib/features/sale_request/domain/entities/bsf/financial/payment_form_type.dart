// lib/features/sale_request/domain/entities/bsf/financial/payment_form_type.dart

enum PaymentFormType {
  userDefined(0),
  money(1),
  check(2),
  creditCard(4),
  bankTicket(5),
  promissoryNote(7),
  checkingAccount(8),
  debitCard(9),
  portion(10),
  pix(11);

  final int value;
  const PaymentFormType(this.value);

  factory PaymentFormType.fromValue(int? value) {
    return PaymentFormType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentFormType.userDefined,
    );
  }
}
