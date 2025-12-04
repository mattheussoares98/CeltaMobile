// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../entities.dart';

class GetProductsByRequestTypeParams extends GetProductsDefaultParams {
  final int enterpriseOriginCode;
  final int enterpriseDestinyCode;
  final int requestTypeCode;

  const GetProductsByRequestTypeParams({
    required super.searchValue,
    super.routine,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeCode,
  });

  @override
  List<Object?> get props => [
    searchValue,
    routine,
    enterpriseOriginCode,
    enterpriseDestinyCode,
    requestTypeCode,
  ];

  @override
  GetProductsByRequestTypeParams copyWith({
    String? searchValue,
    BsRoutine? routine,
    int? enterpriseOriginCode,
    int? enterpriseDestinyCode,
    int? requestTypeCode,
  }) {
    return GetProductsByRequestTypeParams(
      searchValue: searchValue ?? this.searchValue,
      routine: routine ?? this.routine,
      enterpriseOriginCode: enterpriseOriginCode ?? this.enterpriseOriginCode,
      enterpriseDestinyCode:
          enterpriseDestinyCode ?? this.enterpriseDestinyCode,
      requestTypeCode: requestTypeCode ?? this.requestTypeCode,
    );
  }
}
