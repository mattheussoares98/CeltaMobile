import 'package:equatable/equatable.dart';

import '../entities.dart';

class CompetingPricesParams extends Equatable {
  final int ResearchOfPriceCode;
  final int ConcurrentCode;
  final bool OnlyAssociated;
  final SearchProductCompetingPriceType searchType;
  const CompetingPricesParams({
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
