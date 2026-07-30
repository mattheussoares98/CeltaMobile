import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFSaleRequestMarkedSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String personalizedCode;
  final String customer;
  final double totalLiquid;

  const BSFSaleRequestMarkedSynchronizerErrorDetailEntity({
    required this.personalizedCode,
    required this.customer,
    required this.totalLiquid,
  });

  @override
  List<Object?> get props => [personalizedCode, customer, totalLiquid];
}
