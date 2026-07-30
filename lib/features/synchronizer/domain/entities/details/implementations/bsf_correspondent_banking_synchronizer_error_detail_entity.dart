import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFCorrespondentBankingSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final DateTime creationDate;
  final DateTime deliveryDate;
  final String correspondentBankingNumber;
  final String ecfNumber;
  final String cashRegisterNumber;
  final List<String> details;

  const BSFCorrespondentBankingSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.creationDate,
    required this.deliveryDate,
    required this.correspondentBankingNumber,
    required this.ecfNumber,
    required this.cashRegisterNumber,
    required this.details,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    creationDate,
    deliveryDate,
    correspondentBankingNumber,
    ecfNumber,
    cashRegisterNumber,
    details,
  ];
}
