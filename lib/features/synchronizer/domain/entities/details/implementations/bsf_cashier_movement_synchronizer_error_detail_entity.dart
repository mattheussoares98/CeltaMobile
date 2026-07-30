import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFCashierMovementSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final DateTime creationDate;
  final DateTime openOrCloseDate;
  final String cashRegisterPersonalizedCode;
  final String description;

  const BSFCashierMovementSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.creationDate,
    required this.openOrCloseDate,
    required this.cashRegisterPersonalizedCode,
    required this.description,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    creationDate,
    openOrCloseDate,
    cashRegisterPersonalizedCode,
    description,
  ];
}
