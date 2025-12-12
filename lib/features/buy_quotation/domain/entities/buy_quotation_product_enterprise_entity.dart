import 'package:equatable/equatable.dart';

class BuyQuotationProductEnterpriseEntity extends Equatable {
  final int? Code;
  final int? EnterpriseCode;
  final double? Quantity;

  const BuyQuotationProductEnterpriseEntity({
    required this.Code,
    required this.EnterpriseCode,
    required this.Quantity,
  });

  @override
  List<Object?> get props => [Code, EnterpriseCode, Quantity];
}
