import 'package:equatable/equatable.dart';

class SaleRequestArgs extends Equatable {
  final int enterpriseCode;
  final int customerCode; //0 => inserting
  final int saleRequestId; //0 => inserting
  final int? requestTypeCode; //null => inserting

  const SaleRequestArgs({
    required this.enterpriseCode,
    required this.saleRequestId,
    this.customerCode = 0,
    this.requestTypeCode,
  });

  @override
  List<Object?> get props => [
    enterpriseCode,
    customerCode,
    saleRequestId,
    requestTypeCode,
  ];

  bool get isInserting => saleRequestId == 0 || customerCode == 0;

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

  Map<String, String> toPathParametersJson() => {
    'enterpriseCode': enterpriseCode.toString(),
    'customerCode': customerCode.toString(),
    'saleRequestId': saleRequestId.toString(),
    'requestTypeCode': requestTypeCode.toString(),
  };
}
