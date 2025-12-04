// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../entities.dart';

class GetProductsJsonParams extends GetProductsDefaultParams {
  final List<int> EnterpriseCodes;
  final BsRoutine routine;
  final int? LastBuyEntranceQuantity;
  final BuyRequestParams? buyRequestParams;
  final CompetingPricesParams? competingPricesParams;

  const GetProductsJsonParams({
    required super.searchValue,
    required this.EnterpriseCodes,
    required this.routine,
    required this.LastBuyEntranceQuantity,
    required this.buyRequestParams,
    required this.competingPricesParams,
  });
  @override
  List<Object?> get props => [
    EnterpriseCodes,
    routine,
    searchValue,
    LastBuyEntranceQuantity,
    buyRequestParams,
    competingPricesParams,
  ];

  GetProductsJsonParams copyWith({
    List<int>? EnterpriseCodes,
    BsRoutine? routine,
    String? searchValue,
    int? LastBuyEntranceQuantity,
    BuyRequestParams? buyRequestParams,
    CompetingPricesParams? competingPricesParams,
  }) {
    return GetProductsJsonParams(
      EnterpriseCodes: EnterpriseCodes ?? this.EnterpriseCodes,
      routine: routine ?? this.routine,
      searchValue: searchValue ?? this.searchValue,
      LastBuyEntranceQuantity:
          LastBuyEntranceQuantity ?? this.LastBuyEntranceQuantity,
      buyRequestParams: buyRequestParams ?? this.buyRequestParams,
      competingPricesParams:
          competingPricesParams ?? this.competingPricesParams,
    );
  }

  GetProductsJsonParams annulValues({
    bool? LastBuyEntranceQuantity,
    bool? buyRequestParams,
    bool? competingPricesParams,
  }) {
    return GetProductsJsonParams(
      EnterpriseCodes: this.EnterpriseCodes,
      routine: this.routine,
      searchValue: this.searchValue,
      LastBuyEntranceQuantity: LastBuyEntranceQuantity == true
          ? null
          : this.LastBuyEntranceQuantity,
      buyRequestParams: buyRequestParams == true ? null : this.buyRequestParams,
      competingPricesParams: competingPricesParams == true
          ? null
          : this.competingPricesParams,
    );
  }
}
