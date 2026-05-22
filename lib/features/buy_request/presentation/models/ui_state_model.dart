import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class UiStateModel extends Equatable {
  final int currentPageIndex;
  final int? selectedProductIndex;
  final int? selectedCartProductIndex;
  final List<SupplierEntity> suppliers;

  const UiStateModel({
    required this.currentPageIndex,
    required this.selectedProductIndex,
    required this.selectedCartProductIndex,
    required this.suppliers,
  });

  @override
  List<Object?> get props => [
    currentPageIndex,
    selectedProductIndex,
    selectedCartProductIndex,
    suppliers,
  ];

  UiStateModel copyWith({
    int? currentPageIndex,
    int? selectedProductIndex,
    int? selectedCartProductIndex,
    List<SupplierEntity>? suppliers,
  }) {
    return UiStateModel(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      selectedProductIndex: selectedProductIndex ?? this.selectedProductIndex,
      selectedCartProductIndex:
          selectedCartProductIndex ?? this.selectedCartProductIndex,
      suppliers: suppliers ?? this.suppliers,
    );
  }

  UiStateModel annulValues({
    bool? annulCurrentPage,
    bool? annulSelectedProductIndex,
    bool? annulSelectedCartProductIndex,
    bool? annulSuppliers,
  }) => UiStateModel(
    currentPageIndex: annulCurrentPage == true ? 0 : currentPageIndex,
    selectedProductIndex: annulSelectedProductIndex == true
        ? null
        : selectedProductIndex,
    selectedCartProductIndex: annulSelectedCartProductIndex == true
        ? null
        : selectedCartProductIndex,
    suppliers: annulSuppliers == true ? [] : suppliers,
  );
}
