import 'package:equatable/equatable.dart';

class SaleRequestArgs extends Equatable {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;

  const SaleRequestArgs({
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  List<Object?> get props => [enterpriseCode, customerCode, saleRequestId];

  bool get isInserting => saleRequestId == 0 || customerCode == 0;
}
