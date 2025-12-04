// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../entities.dart';

class GetProductsReceiptParams extends GetProductsDefaultParams {
  final int grDocCode;

  const GetProductsReceiptParams({
    super.routine,
    required super.searchValue,
    required this.grDocCode,
  });

  @override
  List<Object?> get props => [searchValue, grDocCode];

  @override
  GetProductsReceiptParams copyWith({
    int? grDocCode,
    String? searchValue,
    BsRoutine? routine,
  }) {
    return GetProductsReceiptParams(
      searchValue: searchValue ?? this.searchValue,
      grDocCode: grDocCode ?? this.grDocCode,
      routine: routine ?? this.routine,
    );
  }
}
