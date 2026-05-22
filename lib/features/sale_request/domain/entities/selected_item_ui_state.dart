import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class SelectedItemUIState extends Equatable {
  final int? productPackingCode;
  final PercentageOrValue? discountType;

  const SelectedItemUIState({
    required this.productPackingCode,
    required this.discountType,
  });

  @override
  List<Object?> get props => [productPackingCode, discountType];

  factory SelectedItemUIState.empty() {
    return const SelectedItemUIState(
      productPackingCode: null,
      discountType: null,
    );
  }

  SelectedItemUIState copyWith({
    int? productPackingCode,
    PercentageOrValue? discountType,
  }) {
    return SelectedItemUIState(
      productPackingCode: productPackingCode ?? this.productPackingCode,
      discountType: discountType ?? this.discountType,
    );
  }
}
