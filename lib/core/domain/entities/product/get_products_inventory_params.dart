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
}
