import 'package:equatable/equatable.dart';

class ProductWithErrorActionParams extends Equatable {
  final int enterpriseCode;
  final int productCode;
  final int productPackingCode;
  final int enterpriseCommerceSiteCode;

  const ProductWithErrorActionParams({
    required this.enterpriseCode,
    required this.productCode,
    required this.productPackingCode,
    required this.enterpriseCommerceSiteCode,
  });

  Map<String, int> toMap() => {
    'EnterpriseCode': enterpriseCode,
    'ProductCode': productCode,
    'ProductPackingCode': productPackingCode,
    'EnterpriseCommerceSiteCode': enterpriseCommerceSiteCode,
  };

  @override
  List<Object?> get props => [
    enterpriseCode,
    productCode,
    productPackingCode,
    enterpriseCommerceSiteCode,
  ];
}
