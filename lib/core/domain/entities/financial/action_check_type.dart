// lib/features/sale_request/domain/entities/bsf/financial/payment_finalization_action_check_type.dart

enum ActionCheckType {
  analytical(1),
  consolidate(2),
  notApply(3);

  final int value;
  const ActionCheckType(this.value);

  factory ActionCheckType.fromValue(int? value) {
    return ActionCheckType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ActionCheckType.notApply,
    );
  }
}
