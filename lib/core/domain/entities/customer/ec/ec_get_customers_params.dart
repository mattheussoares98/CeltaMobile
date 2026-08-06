import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcGetCustomersParams extends Equatable {
  final EcRequestParams params;
  final String searchValue;
  final int enterpriseCode;
  final int? sellerCode;
  final bool searchByPersonalizedCode;

  const EcGetCustomersParams({
    required this.params,
    required this.searchValue,
    required this.enterpriseCode,
    this.sellerCode,
    required this.searchByPersonalizedCode,
  });

  @override
  List<Object?> get props => [
    params,
    searchValue,
    enterpriseCode,
    sellerCode,
    searchByPersonalizedCode,
  ];

  Map<String, dynamic> toJson() {
    return {
      'params': params.toMap(),
      'searchValue': searchValue,
      'enterpriseCode': enterpriseCode,
      'sellerCode': sellerCode,
      'searchByPersonalizedCode': searchByPersonalizedCode,
    };
  }
}
