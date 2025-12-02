import 'package:equatable/equatable.dart';

class BuyRequestParams extends Equatable {
  final int requestTypeCode;
  final int supplierCode;
  const BuyRequestParams({
    required this.requestTypeCode,
    required this.supplierCode,
  });

  @override
  List<Object?> get props => [requestTypeCode, supplierCode];
}
