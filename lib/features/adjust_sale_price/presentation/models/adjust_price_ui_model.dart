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
}
