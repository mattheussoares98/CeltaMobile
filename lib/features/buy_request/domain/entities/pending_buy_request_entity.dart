import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

class PendingBuyRequestEntity extends Equatable {
  final BuyerEntity? selectedBuyer;
  final SupplierEntity? selectedSupplier;
  final List<EnterpriseEntity>? selectedEnterprises;

  const PendingBuyRequestEntity({
    required this.selectedBuyer,
    required this.selectedSupplier,
    required this.selectedEnterprises,
  });

  @override
  List<Object?> get props => [
    selectedBuyer,
    selectedSupplier,
    selectedEnterprises,
  ];

  PendingBuyRequestEntity copyWith({
    BuyerEntity? selectedBuyer,
    SupplierEntity? selectedSupplier,
    List<EnterpriseEntity>? selectedEnterprises,
  }) {
    return PendingBuyRequestEntity(
      selectedBuyer: selectedBuyer ?? this.selectedBuyer,
      selectedSupplier: selectedSupplier ?? this.selectedSupplier,
      selectedEnterprises: selectedEnterprises ?? this.selectedEnterprises,
    );
  }

  factory PendingBuyRequestEntity.empty() => const PendingBuyRequestEntity(
    selectedBuyer: null,
    selectedSupplier: null,
    selectedEnterprises: null,
  );
}
