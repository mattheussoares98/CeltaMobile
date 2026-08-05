import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFSaleRequestMarkedSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity
    implements SelectableSynchronizerErrorDetailEntity {
  final int code;
  final String personalizedCode;
  final String customer;
  final double totalLiquid;

  const BSFSaleRequestMarkedSynchronizerErrorDetailEntity({
    required this.code,
    required this.personalizedCode,
    required this.customer,
    required this.totalLiquid,
  });

  @override
  List<Object?> get props => [code, personalizedCode, customer, totalLiquid];

  @override
  List<int> get selectableCodes => [code];
}
