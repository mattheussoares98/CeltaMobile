// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  BuyQuotationProductEnterpriseEntity copyWith({
    int? Code,
    int? EnterpriseCode,
    double? Quantity,
  }) {
    return BuyQuotationProductEnterpriseEntity(
      Code: Code ?? this.Code,
      EnterpriseCode: EnterpriseCode ?? this.EnterpriseCode,
      Quantity: Quantity ?? this.Quantity,
    );
  }
}
