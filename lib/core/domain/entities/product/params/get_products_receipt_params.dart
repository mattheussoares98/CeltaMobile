// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../entities.dart';

class GetProductsReceiptParams extends GetProductsDefaultParams {
  final int grDocCode;

  const GetProductsReceiptParams({
    required super.searchValue,
    required this.grDocCode,
  });

  @override
  List<Object?> get props => [searchValue, grDocCode];

  GetProductsReceiptParams copyWith({int? grDocCode, String? searchValue}) {
    return GetProductsReceiptParams(
      searchValue: searchValue ?? this.searchValue,
      grDocCode: grDocCode ?? this.grDocCode,
    );
  }
}
