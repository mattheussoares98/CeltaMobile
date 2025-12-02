// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../entities.dart';

class GetProductsInventoryParams extends GetProductsDefaultParams {
  final int inventoryProcessCode;
  final int inventoryCountingCode;

  const GetProductsInventoryParams({
    required super.searchValue,
    required super.searchType,
    required this.inventoryProcessCode,
    required this.inventoryCountingCode,
  });

  @override
  List<Object?> get props => [
    searchValue,
    searchType,
    inventoryProcessCode,
    inventoryCountingCode,
  ];

  GetProductsInventoryParams copyWith({
    int? inventoryProcessCode,
    int? inventoryCountingCode,
    String? searchValue,
    SearchType? searchType,
  }) {
    return GetProductsInventoryParams(
      searchType: searchType ?? this.searchType,
      searchValue: searchValue ?? this.searchValue,
      inventoryProcessCode: inventoryProcessCode ?? this.inventoryProcessCode,
      inventoryCountingCode:
          inventoryCountingCode ?? this.inventoryCountingCode,
    );
  }
}
