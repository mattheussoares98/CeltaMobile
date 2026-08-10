import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcSaleMovementScanntechLoadSynchronizerErrorDetailEntity
    extends EcSynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final DateTime creationDate;
  final DateTime billingDate;
  final String cashierNumber;
  final String ecfNumber;
  final String documentNumber;
  final String description;

  const EcSaleMovementScanntechLoadSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.creationDate,
    required this.billingDate,
    required this.cashierNumber,
    required this.ecfNumber,
    required this.documentNumber,
    required this.description,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    creationDate,
    billingDate,
    cashierNumber,
    ecfNumber,
    documentNumber,
    description,
  ];
}
