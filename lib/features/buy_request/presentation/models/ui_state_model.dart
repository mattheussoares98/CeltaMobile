import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

class UiStateModel extends Equatable {
  final int currentPageIndex;
  final int? selectedProductIndex;
  final List<SupplierEntity> suppliers;

  const UiStateModel({
    required this.currentPageIndex,
    required this.selectedProductIndex,
    required this.suppliers,
  });

  @override
  List<Object?> get props => [
    currentPageIndex,
    selectedProductIndex,
    suppliers,
  ];

  UiStateModel copyWith({
    int? currentPageIndex,
    int? selectedProductIndex,
    List<SupplierEntity>? suppliers,
  }) {
    return UiStateModel(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      selectedProductIndex: selectedProductIndex ?? this.selectedProductIndex,
      suppliers: suppliers ?? this.suppliers,
    );
  }

  UiStateModel annulValues({
    bool? annulCurrentPage,
    bool? annulSelectedProductIndex,
    bool? annulSuppliers,
  }) => UiStateModel(
    currentPageIndex: annulCurrentPage == true ? 0 : currentPageIndex,
    selectedProductIndex: annulSelectedProductIndex == true
        ? null
        : selectedProductIndex,
    suppliers: annulSuppliers == true ? [] : suppliers,
  );
}
