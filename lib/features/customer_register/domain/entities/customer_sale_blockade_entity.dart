import 'package:equatable/equatable.dart';

class CustomerSaleBlockadeEntity extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String LegacyCode;
  final String Description;
  final bool AllowSaleRequest;
  final bool AllowSale;
  final bool AllowSaleWithPaymentFinalizationTypeCheckOrPortion;
  const CustomerSaleBlockadeEntity({
    required this.Code,
    required this.PersonalizedCode,
    required this.LegacyCode,
    required this.Description,
    required this.AllowSaleRequest,
    required this.AllowSale,
    required this.AllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  });

  @override
  List<Object?> get props => [
    Code,
    PersonalizedCode,
    LegacyCode,
    Description,
    AllowSaleRequest,
    AllowSale,
    AllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  ];

  CustomerSaleBlockadeEntity copyWith({
    int? Code,
    String? PersonalizedCode,
    String? LegacyCode,
    String? Description,
    bool? AllowSaleRequest,
    bool? AllowSale,
    bool? AllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  }) {
    return CustomerSaleBlockadeEntity(
      Code: Code ?? this.Code,
      PersonalizedCode: PersonalizedCode ?? this.PersonalizedCode,
      LegacyCode: LegacyCode ?? this.LegacyCode,
      Description: Description ?? this.Description,
      AllowSaleRequest: AllowSaleRequest ?? this.AllowSaleRequest,
      AllowSale: AllowSale ?? this.AllowSale,
      AllowSaleWithPaymentFinalizationTypeCheckOrPortion:
          AllowSaleWithPaymentFinalizationTypeCheckOrPortion ??
          this.AllowSaleWithPaymentFinalizationTypeCheckOrPortion,
    );
  }
}
