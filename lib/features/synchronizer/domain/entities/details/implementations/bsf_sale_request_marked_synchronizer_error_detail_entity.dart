import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFSaleRequestMarkedSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity
    implements SelectableSynchronizerErrorDetailEntity {
  final int code;
  final String personalizedCode;
  final String customer;
  final double totalLiquid;
  final int customerCode;
  final int requestTypeCode;
  final int enterpriseCode;

  const BSFSaleRequestMarkedSynchronizerErrorDetailEntity({
    required this.code,
    required this.personalizedCode,
    required this.customer,
    required this.totalLiquid,
    required this.customerCode,
    required this.requestTypeCode,
    required this.enterpriseCode,
  });

  @override
  List<Object?> get props => [
    code,
    personalizedCode,
    customer,
    totalLiquid,
    customerCode,
    requestTypeCode,
    enterpriseCode,
  ];

  @override
  List<int> get selectableCodes => [code];
}
