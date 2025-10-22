import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../models/models.dart';

abstract class ISoapProductsDatasource {
  Future<List<ProductModel>> getProductsJson({
    required String baseUrl,
    required String searchValue,
    required BsRoutine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    required EnterpriseEntity enterpriseEntity,
    required int? lastBuyEntranceQuantity,
    required BuyRequestFilters? buyRequestFilters,
  });
}

class BuyRequestFilters extends Equatable {
  final int requestTypeCode;
  final int supplierCode;
  const BuyRequestFilters({
    required this.requestTypeCode,
    required this.supplierCode,
  });

  @override
  List<Object?> get props => [requestTypeCode, supplierCode];
}
