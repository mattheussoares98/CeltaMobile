import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';

class BSFProductDetailsModel extends Equatable {
  final String? name;
  final bool? isAlcoholicProduct;
  final bool? isFatherOfGrate;
  final int? fatherGrateCode;
  final dynamic images;
  final String? personalizedCode;
  final String? productPackingTypeString;
  final double? productPackingQuantity;
  final String? productPackingPriceLookUpString;

  const BSFProductDetailsModel({
    required this.name,
    required this.isAlcoholicProduct,
    required this.isFatherOfGrate,
    required this.fatherGrateCode,
    required this.images,
    required this.personalizedCode,
    required this.productPackingTypeString,
    required this.productPackingQuantity,
    required this.productPackingPriceLookUpString,
  });

  @override
  List<Object?> get props => [
    name,
    isAlcoholicProduct,
    isFatherOfGrate,
    fatherGrateCode,
    images,
    personalizedCode,
    productPackingTypeString,
    productPackingQuantity,
    productPackingPriceLookUpString,
  ];

  factory BSFProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      BSFProductDetailsModel(
        name: json['Name'],
        isAlcoholicProduct: json['IsAlcoholicProduct'],
        isFatherOfGrate: json['IsFatherOfGrate'],
        fatherGrateCode: json['FatherGrateCode'],
        images: json['Images'],
        personalizedCode: json['PersonalizedCode'],
        productPackingTypeString: json['ProductPackingTypeString'],
        productPackingQuantity: (json['ProductPackingQuantity'] as num?)
            ?.toDouble(),
        productPackingPriceLookUpString:
            json['ProductPackingPriceLookUpString'],
      );

  Map<String, dynamic> toJson() => {
    'Name': name,
    'IsAlcoholicProduct': isAlcoholicProduct,
    'IsFatherOfGrate': isFatherOfGrate,
    'FatherGrateCode': fatherGrateCode,
    'Images': images,
    'PersonalizedCode': personalizedCode,
    'ProductPackingTypeString': productPackingTypeString,
    'ProductPackingQuantity': productPackingQuantity,
    'ProductPackingPriceLookUpString': productPackingPriceLookUpString,
  };

  factory BSFProductDetailsModel.fromEntity(BSFProductDetailsEntity entity) =>
      BSFProductDetailsModel(
        name: entity.name,
        isAlcoholicProduct: entity.isAlcoholicProduct,
        isFatherOfGrate: entity.isFatherOfGrate,
        fatherGrateCode: entity.fatherGrateCode,
        images: entity.images,
        personalizedCode: entity.personalizedCode,
        productPackingTypeString: entity.productPackingTypeString,
        productPackingQuantity: entity.productPackingQuantity,
        productPackingPriceLookUpString: entity.productPackingPriceLookUpString,
      );

  BSFProductDetailsEntity toEntity() => BSFProductDetailsEntity(
    name: name,
    isAlcoholicProduct: isAlcoholicProduct,
    isFatherOfGrate: isFatherOfGrate,
    fatherGrateCode: fatherGrateCode,
    images: images,
    personalizedCode: personalizedCode,
    productPackingTypeString: productPackingTypeString,
    productPackingQuantity: productPackingQuantity,
    productPackingPriceLookUpString: productPackingPriceLookUpString,
  );
}
