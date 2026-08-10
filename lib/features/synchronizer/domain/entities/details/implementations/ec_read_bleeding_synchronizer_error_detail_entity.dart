import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcReadBleedingSynchronizerErrorDetailEntity
    extends EcSynchronizerErrorDetailEntity
    implements EcSelectableSynchronizerErrorDetailEntity {
  final int code;
  final bool markedToReadAgain;
  final String enterprisePersonalizedCode;
  final DateTime creationDate;
  final DateTime movementDate;
  final String cashierNumber;
  final String description;

  const EcReadBleedingSynchronizerErrorDetailEntity({
    required this.code,
    required this.markedToReadAgain,
    required this.enterprisePersonalizedCode,
    required this.creationDate,
    required this.movementDate,
    required this.cashierNumber,
    required this.description,
  });

  @override
  List<Object?> get props => [
    code,
    markedToReadAgain,
    enterprisePersonalizedCode,
    creationDate,
    movementDate,
    cashierNumber,
    description,
  ];

  @override
  List<int> get selectableCodes => [code];
}
