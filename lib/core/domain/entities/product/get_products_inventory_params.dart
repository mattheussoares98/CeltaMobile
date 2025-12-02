import 'package:equatable/equatable.dart';

import '../entities.dart';

class GetProductsInventoryParams extends Equatable {
  final int searchValue;
  final SearchType searchType;
  final int inventoryProcessCode;
  final int inventoryCountingCode;

  const GetProductsInventoryParams({
    required this.searchValue,
    required this.searchType,
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
