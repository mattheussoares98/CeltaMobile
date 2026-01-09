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
}
