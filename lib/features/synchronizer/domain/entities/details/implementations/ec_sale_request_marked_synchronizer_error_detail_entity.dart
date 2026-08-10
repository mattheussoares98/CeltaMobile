import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcSaleRequestMarkedSynchronizerErrorDetailEntity
    extends EcSynchronizerErrorDetailEntity
    implements EcSelectableSynchronizerErrorDetailEntity {
  final int code;
  final String personalizedCode;
  final String customer;
  final double totalLiquid;
  final int customerCode;
  final int requestTypeCode;
  final int enterpriseCode;

  const EcSaleRequestMarkedSynchronizerErrorDetailEntity({
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
