import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [name, personalizedCode];
}
