// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:celta_inventario/core/domain/entities/entities.dart';

class GetProductsJsonParams extends GetProductsDefaultParams {
  final List<int> enterpriseCodes;
  final int? lastBuyEntranceQuantity;
  final BuyRequestParams? buyRequestParams;
  final CompetingPricesParams? competingPricesParams;

  const GetProductsJsonParams({
    required super.searchValue,
    required this.enterpriseCodes,
    super.routine,
    this.lastBuyEntranceQuantity,
    this.buyRequestParams,
    this.competingPricesParams,
  });
  @override
  List<Object?> get props => [
    enterpriseCodes,
    routine,
    searchValue,
    lastBuyEntranceQuantity,
    buyRequestParams,
    competingPricesParams,
  ];

  @override
  GetProductsJsonParams copyWith({
    List<int>? EnterpriseCodes,
    BsRoutine? routine,
    String? searchValue,
    int? LastBuyEntranceQuantity,
    BuyRequestParams? buyRequestParams,
    CompetingPricesParams? competingPricesParams,
  }) {
    return GetProductsJsonParams(
      enterpriseCodes: EnterpriseCodes ?? this.enterpriseCodes,
      routine: routine ?? this.routine,
      searchValue: searchValue ?? this.searchValue,
      lastBuyEntranceQuantity:
          LastBuyEntranceQuantity ?? this.lastBuyEntranceQuantity,
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
      enterpriseCodes: this.enterpriseCodes,
      routine: this.routine,
      searchValue: this.searchValue,
      lastBuyEntranceQuantity: LastBuyEntranceQuantity == true
          ? null
          : this.lastBuyEntranceQuantity,
      buyRequestParams: buyRequestParams == true ? null : this.buyRequestParams,
      competingPricesParams: competingPricesParams == true
          ? null
          : this.competingPricesParams,
    );
  }
}
