import 'package:equatable/equatable.dart';

class SaleRequestArgs extends Equatable {
  final int enterpriseCode;
  final int customerCode; //0 => inserting
  final int saleRequestId; //0 => inserting
  final int? requestTypeCode; //null => inserting

  const SaleRequestArgs({
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
    this.requestTypeCode,
  });

  @override
  List<Object?> get props => [
    enterpriseCode,
    customerCode,
    saleRequestId,
    requestTypeCode,
  ];

  bool get isInserting =>
      saleRequestId == 0 || customerCode == 0 || requestTypeCode == null;

  SaleRequestArgs copyWith({
    int? enterpriseCode,
    int? customerCode,
    int? saleRequestId,
    int? requestTypeCode,
  }) {
    return SaleRequestArgs(
      enterpriseCode: enterpriseCode ?? this.enterpriseCode,
      customerCode: customerCode ?? this.customerCode,
      saleRequestId: saleRequestId ?? this.saleRequestId,
      requestTypeCode: requestTypeCode ?? this.saleRequestId,
    );
  }
}
