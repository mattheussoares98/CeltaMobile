import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

class PendingBuyRequestEntity extends Equatable {
  final BuyerEntity? selectedBuyer;
  final RequestTypeEntity? selectedRequestType;
  final SupplierEntity? selectedSupplier;
  final List<EnterpriseEntity>? selectedEnterprises;

  const PendingBuyRequestEntity({
    required this.selectedBuyer,
    required this.selectedRequestType,
    required this.selectedSupplier,
    required this.selectedEnterprises,
  });

  @override
  List<Object?> get props => [
    selectedBuyer,
    selectedRequestType,
    selectedSupplier,
    selectedEnterprises,
  ];

  PendingBuyRequestEntity copyWith({
    BuyerEntity? selectedBuyer,
    SupplierEntity? selectedSupplier,
    List<EnterpriseEntity>? selectedEnterprises,
    RequestTypeEntity? selectedRequestType,
  }) {
    return PendingBuyRequestEntity(
      selectedBuyer: selectedBuyer ?? this.selectedBuyer,
      selectedSupplier: selectedSupplier ?? this.selectedSupplier,
      selectedEnterprises: selectedEnterprises ?? this.selectedEnterprises,
      selectedRequestType: selectedRequestType ?? this.selectedRequestType,
    );
  }

  PendingBuyRequestEntity annulValue({
    bool? annulSelectedBuyer,
    bool? annulSelectedSupplier,
    bool? annulSelectedEnterprises,
    bool? annulSelectedRequestType,
  }) {
    return PendingBuyRequestEntity(
      selectedBuyer: annulSelectedBuyer == true ? null : this.selectedBuyer,
      selectedSupplier: annulSelectedSupplier == true
          ? null
          : this.selectedSupplier,
      selectedEnterprises: annulSelectedEnterprises == true
          ? null
          : this.selectedEnterprises,
      selectedRequestType: annulSelectedRequestType == true
          ? null
          : this.selectedRequestType,
    );
  }

  factory PendingBuyRequestEntity.empty() => const PendingBuyRequestEntity(
    selectedBuyer: null,
    selectedSupplier: null,
    selectedEnterprises: null,
    selectedRequestType: null,
  );
}
