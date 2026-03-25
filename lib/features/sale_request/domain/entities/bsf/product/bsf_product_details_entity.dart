import 'package:equatable/equatable.dart';

class BSFProductDetailsEntity extends Equatable {
  final String? name;
  final bool? isAlcoholicProduct;
  final bool? isFatherOfGrate;
  final int? fatherGrateCode;
  final dynamic images;
  final String? personalizedCode;
  final String? productPackingTypeString;
  final double? productPackingQuantity;
  final String? productPackingPriceLookUpString;

  const BSFProductDetailsEntity({
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
  List<Object?> get props => [name, personalizedCode];
}
