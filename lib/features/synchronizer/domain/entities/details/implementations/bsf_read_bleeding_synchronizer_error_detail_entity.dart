import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFReadBleedingSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity
    implements SelectableSynchronizerErrorDetailEntity {
  final int code;
  final String enterprisePersonalizedCode;
  final DateTime creationDate;
  final DateTime movementDate;
  final String cashierNumber;
  final String description;

  const BSFReadBleedingSynchronizerErrorDetailEntity({
    required this.code,
    required this.enterprisePersonalizedCode,
    required this.creationDate,
    required this.movementDate,
    required this.cashierNumber,
    required this.description,
  });

  @override
  List<Object?> get props => [
    code,
    enterprisePersonalizedCode,
    creationDate,
    movementDate,
    cashierNumber,
    description,
  ];

  @override
  List<int> get selectableCodes => [code];
}
