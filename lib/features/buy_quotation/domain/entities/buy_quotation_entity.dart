import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

class BuyQuotationEntity extends Equatable {
  final int Code;
  final String DateOfCreation;
  final String DateOfLimit;
  final String PersonalizedCode;
  final String? Observations;
  final BuyerEntity? Buyer;
  final List<BuyQuotationEnterpriseEntity>? Enterprises;
  final List<BuyQuotationProductsEntity>? Products;

  const BuyQuotationEntity({
    required this.Code,
    required this.DateOfCreation,
    required this.DateOfLimit,
    required this.PersonalizedCode,
    required this.Observations,
    required this.Buyer,
    required this.Enterprises,
    required this.Products,
  });

  @override
  List<Object?> get props => [
    Code,
    DateOfCreation,
    DateOfLimit,
    PersonalizedCode,
    Observations,
    Buyer,
    Enterprises,
    Products,
  ];
}
