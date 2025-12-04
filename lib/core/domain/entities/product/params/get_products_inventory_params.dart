// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../entities.dart';

class GetProductsInventoryParams extends GetProductsDefaultParams {
  final int inventoryProcessCode;
  final int inventoryCountingCode;

  const GetProductsInventoryParams({
    required super.searchValue,
    super.routine,
    required this.inventoryProcessCode,
    required this.inventoryCountingCode,
  });

  @override
  List<Object?> get props => [
    searchValue,
    routine,
    inventoryProcessCode,
    inventoryCountingCode,
  ];

  @override
  GetProductsInventoryParams copyWith({
    int? inventoryProcessCode,
    int? inventoryCountingCode,
    String? searchValue,
    BsRoutine? routine,
  }) {
    return GetProductsInventoryParams(
      searchValue: searchValue ?? this.searchValue,
      routine: routine ?? this.routine,
      inventoryProcessCode: inventoryProcessCode ?? this.inventoryProcessCode,
      inventoryCountingCode:
          inventoryCountingCode ?? this.inventoryCountingCode,
    );
  }
}
