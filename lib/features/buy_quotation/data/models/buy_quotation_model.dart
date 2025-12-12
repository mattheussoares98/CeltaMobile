import 'package:equatable/equatable.dart';

import '../../../../core/data/models/models.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class BuyQuotationModel extends Equatable {
  final int Code;
  final DateTime DateOfCreation;
  final DateTime DateOfLimit;
  final String PersonalizedCode;
  final String? Observations;
  final BuyerModel? Buyer;
  final List<BuyQuotationEnterpriseModel>? Enterprises;
  final List<BuyQuotationProductsModel>? Products;

  const BuyQuotationModel({
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

  factory BuyQuotationModel.fromJson(Map json) => BuyQuotationModel(
    Code: json["Code"],
    DateOfCreation: DateTime.parse(json["DateOfCreation"]),
    DateOfLimit: DateTime.parse(json["DateOfLimit"]),
    PersonalizedCode: json["PersonalizedCode"],
    Observations: json["Observations"],
    Buyer: json["Buyer"] != null ? BuyerModel.fromJson(json["Buyer"]) : null,
    Enterprises: json["Enterprises"] != null
        ? List<BuyQuotationEnterpriseModel>.from(
            json["Enterprises"].map(
              (x) => BuyQuotationEnterpriseModel.fromJson(x),
            ),
          )
        : null,
    Products: json["Products"] != null
        ? List<BuyQuotationProductsModel>.from(
            json["Products"].map((x) => BuyQuotationProductsModel.fromJson(x)),
          )
        : null,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'DateOfCreation': DateOfCreation.toIso8601String(),
    'DateOfLimit': DateOfLimit.toIso8601String(),
    'PersonalizedCode': PersonalizedCode,
    'Observations': Observations,
    'Buyer': Buyer?.toJson(),
    'Enterprises': Enterprises?.map((e) => e.toJson()).toList(),
    'Products': Products?.map((e) => e.toJson()).toList(),
  };

  factory BuyQuotationModel.fromEntity(BuyQuotationEntity entity) =>
      BuyQuotationModel(
        Code: entity.Code,
        DateOfCreation: entity.DateOfCreation,
        DateOfLimit: entity.DateOfLimit,
        PersonalizedCode: entity.PersonalizedCode,
        Observations: entity.Observations,
        Buyer: entity.Buyer == null
            ? null
            : BuyerModel.fromEntity(entity.Buyer!),
        Enterprises: entity.Enterprises?.map(
          (e) => BuyQuotationEnterpriseModel.fromEntity(e),
        ).toList(),
        Products: entity.Products?.map(
          (e) => BuyQuotationProductsModel.fromEntity(e),
        ).toList(),
      );
}
