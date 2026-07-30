import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFReadBleedingSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final DateTime creationDate;
  final DateTime movementDate;
  final String cashierNumber;
  final String description;

  const BSFReadBleedingSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.creationDate,
    required this.movementDate,
    required this.cashierNumber,
    required this.description,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    creationDate,
    movementDate,
    cashierNumber,
    description,
  ];
}
