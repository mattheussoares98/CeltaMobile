// lib/features/sale_request/domain/entities/bsf/financial/card_terminal_type.dart

enum CardTerminalType {
  tef(1),
  pos(2),
  notApply(3);

  final int value;
  const CardTerminalType(this.value);

  factory CardTerminalType.fromValue(int? value) {
    return CardTerminalType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CardTerminalType.notApply,
    );
  }
}
