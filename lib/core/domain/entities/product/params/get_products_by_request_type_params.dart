// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../entities.dart';
import 'params.dart';

class GetProductsByRequestTypeParams extends GetProductsDefaultParams {
  final int enterpriseOriginCode;
  final int enterpriseDestinyCode;
  final int requestTypeCode;

  const GetProductsByRequestTypeParams({
    required super.searchValue,
    required super.searchType,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeCode,
  });

  @override
  List<Object?> get props => [
    searchValue,
    searchType,
    enterpriseOriginCode,
    enterpriseDestinyCode,
    requestTypeCode,
  ];

  GetProductsByRequestTypeParams copyWith({
    String? searchValue,
    SearchType? searchType,
    int? enterpriseOriginCode,
    int? enterpriseDestinyCode,
    int? requestTypeCode,
  }) {
    return GetProductsByRequestTypeParams(
      searchValue: searchValue ?? this.searchValue,
      searchType: searchType ?? this.searchType,
      enterpriseOriginCode: enterpriseOriginCode ?? this.enterpriseOriginCode,
      enterpriseDestinyCode:
          enterpriseDestinyCode ?? this.enterpriseDestinyCode,
      requestTypeCode: requestTypeCode ?? this.requestTypeCode,
    );
  }
}
