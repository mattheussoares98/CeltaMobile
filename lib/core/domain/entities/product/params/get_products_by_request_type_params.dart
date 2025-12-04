// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../entities.dart';

class GetProductsByRequestTypeParams extends GetProductsDefaultParams {
  final int enterpriseOriginCode;
  final int enterpriseDestinyCode;
  final int requestTypeCode;

  const GetProductsByRequestTypeParams({
    required super.searchValue,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeCode,
  });

  @override
  List<Object?> get props => [
    searchValue,
    enterpriseOriginCode,
    enterpriseDestinyCode,
    requestTypeCode,
  ];

  GetProductsByRequestTypeParams copyWith({
    String? searchValue,
    int? enterpriseOriginCode,
    int? enterpriseDestinyCode,
    int? requestTypeCode,
  }) {
    return GetProductsByRequestTypeParams(
      searchValue: searchValue ?? this.searchValue,
      enterpriseOriginCode: enterpriseOriginCode ?? this.enterpriseOriginCode,
      enterpriseDestinyCode:
          enterpriseDestinyCode ?? this.enterpriseDestinyCode,
      requestTypeCode: requestTypeCode ?? this.requestTypeCode,
    );
  }
}
