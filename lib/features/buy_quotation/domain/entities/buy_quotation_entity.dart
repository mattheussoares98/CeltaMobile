import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

class BuyQuotationEntity extends Equatable {
  final int? Code;
  final DateTime? DateOfCreation;
  final DateTime? DateOfLimit;
  final String? PersonalizedCode;
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

  factory BuyQuotationEntity.empty() => const BuyQuotationEntity(
    Code: null,
    DateOfCreation: null,
    DateOfLimit: null,
    PersonalizedCode: null,
    Observations: null,
    Buyer: null,
    Enterprises: null,
    Products: null,
  );
}
