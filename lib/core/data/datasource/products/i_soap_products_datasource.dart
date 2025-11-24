import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'products.dart';

abstract class ISoapProductsDatasource {
  Future<List<ProductModelType>> getProductsJson({
    required String baseUrl,
    required String searchValue,
    required BsRoutine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    required EnterpriseEntity enterpriseEntity,
    required int? lastBuyEntranceQuantity,
    required BuyRequestFilters? buyRequestFilters,
    required CompetingPricesFilters? competingPricesFilters,
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

class CompetingPricesFilters extends Equatable {
  final int ResearchOfPriceCode;
  final int ConcurrentCode;
  final bool OnlyAssociated;
  final SearchProductCompetingPriceType searchType;
  const CompetingPricesFilters({
    required this.ResearchOfPriceCode,
    required this.ConcurrentCode,
    required this.OnlyAssociated,
    required this.searchType,
  });
  @override
  List<Object?> get props => [
    ResearchOfPriceCode,
    ConcurrentCode,
    OnlyAssociated,
    searchType,
  ];
}
