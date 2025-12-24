// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class AdjustPriceUIModel extends Equatable {
  final SaleType? selectedSaleType;
  final PriceType? selectedPriceType;
  final bool? isSelectedClass;
  final bool? isSelectedGrid;
  final bool? isSelectedOperationalGrouping;
  final bool? isSelectedPackings;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final Set<ReplicationTypes> selectedReplications;
  final List<ReplicationTypes> availableReplications;

  const AdjustPriceUIModel({
    this.selectedSaleType = SaleType.retail,
    this.selectedPriceType = PriceType.sale,
    this.isSelectedClass,
    this.isSelectedGrid,
    this.isSelectedOperationalGrouping,
    this.isSelectedPackings,
    this.selectedStartDate,
    this.selectedEndDate,
    this.selectedReplications = const <ReplicationTypes>{},
    this.availableReplications = const <ReplicationTypes>[],
  });

  @override
  List<Object?> get props => [
    selectedSaleType,
    selectedPriceType,
    isSelectedClass,
    isSelectedGrid,
    isSelectedOperationalGrouping,
    isSelectedPackings,
    selectedStartDate,
    selectedEndDate,
    selectedReplications,
    availableReplications,
  ];

  AdjustPriceUIModel copyWith({
    SaleType? selectedSaleType,
    PriceType? selectedPriceType,
    bool? isSelectedClass,
    bool? isSelectedGrid,
    bool? isSelectedOperationalGrouping,
    bool? isSelectedPackings,
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
    Set<ReplicationTypes>? selectedReplications,
    List<ReplicationTypes>? availableReplications,
  }) {
    return AdjustPriceUIModel(
      selectedSaleType: selectedSaleType ?? this.selectedSaleType,
      selectedPriceType: selectedPriceType ?? this.selectedPriceType,
      isSelectedClass: isSelectedClass ?? this.isSelectedClass,
      isSelectedGrid: isSelectedGrid ?? this.isSelectedGrid,
      isSelectedOperationalGrouping:
          isSelectedOperationalGrouping ?? this.isSelectedOperationalGrouping,
      isSelectedPackings: isSelectedPackings ?? this.isSelectedPackings,
      selectedStartDate: selectedStartDate ?? this.selectedStartDate,
      selectedEndDate: selectedEndDate ?? this.selectedEndDate,
      selectedReplications: selectedReplications ?? this.selectedReplications,
      availableReplications:
          availableReplications ?? this.availableReplications,
    );
  }
}
