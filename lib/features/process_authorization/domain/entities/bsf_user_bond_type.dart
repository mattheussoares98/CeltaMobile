// lib/features/process_authorization/domain/entities/bsf_user_bond_type.dart
enum BSFUserBondType {
  employee(1, 'Funcionário'),
  customer(2, 'Cliente'),
  supplier(3, 'Fornecedor'),
  simpleUser(4, 'Simples');

  final int value;
  final String label;
  const BSFUserBondType(this.value, this.label);

  factory BSFUserBondType.fromValue(int? value) {
    return BSFUserBondType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BSFUserBondType.simpleUser,
    );
  }
}
