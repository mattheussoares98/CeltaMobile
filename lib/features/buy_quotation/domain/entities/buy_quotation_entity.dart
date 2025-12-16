// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  BuyQuotationEntity copyWith({
    int? Code,
    DateTime? DateOfCreation,
    DateTime? DateOfLimit,
    String? PersonalizedCode,
    String? Observations,
    BuyerEntity? Buyer,
    List<BuyQuotationEnterpriseEntity>? Enterprises,
    List<BuyQuotationProductsEntity>? Products,
  }) {
    return BuyQuotationEntity(
      Code: Code ?? this.Code,
      DateOfCreation: DateOfCreation ?? this.DateOfCreation,
      DateOfLimit: DateOfLimit ?? this.DateOfLimit,
      PersonalizedCode: PersonalizedCode ?? this.PersonalizedCode,
      Observations: Observations ?? this.Observations,
      Buyer: Buyer ?? this.Buyer,
      Enterprises: Enterprises ?? this.Enterprises,
      Products: Products ?? this.Products,
    );
  }

  BuyQuotationEntity annulValues({
    bool? annulBuyer,
    bool? annulEnterprises,
    bool? annulProducts,
  }) {
    return BuyQuotationEntity(
      Code: Code,
      DateOfCreation: DateOfCreation,
      DateOfLimit: DateOfLimit,
      PersonalizedCode: PersonalizedCode,
      Observations: Observations,
      Buyer: annulBuyer == true ? null : Buyer,
      Enterprises: annulEnterprises == true ? null : Enterprises,
      Products: annulProducts == true ? null : Products,
    );
  }
}
