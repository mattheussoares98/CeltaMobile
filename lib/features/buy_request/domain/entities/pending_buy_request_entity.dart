import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

class PendingBuyRequestEntity extends Equatable {
  final BuyerEntity? selectedBuyer;
  final BSFRequestTypeEntity? selectedRequestType;
  final SupplierEntity? selectedSupplier;
  final List<EnterpriseEntity>? selectedEnterprises;
  final Map<ProductKey, BuyRequestProductItemEntity>? products;
  final String? lastSavedRequestNumber;

  const PendingBuyRequestEntity({
    required this.selectedBuyer,
    required this.selectedRequestType,
    required this.selectedSupplier,
    required this.selectedEnterprises,
    required this.products,
    required this.lastSavedRequestNumber,
  });

  @override
  List<Object?> get props => [
    selectedBuyer,
    selectedRequestType,
    selectedSupplier,
    selectedEnterprises,
    products,
    lastSavedRequestNumber,
  ];

  bool get canSave {
    return selectedBuyer != null &&
        selectedRequestType != null &&
        selectedSupplier != null &&
        selectedEnterprises?.isNotEmpty == true &&
        products?.isNotEmpty == true;
  }

  PendingBuyRequestEntity copyWith({
    BuyerEntity? selectedBuyer,
    SupplierEntity? selectedSupplier,
    List<EnterpriseEntity>? selectedEnterprises,
    BSFRequestTypeEntity? selectedRequestType,
    Map<ProductKey, BuyRequestProductItemEntity>? products,
    String? lastSavedRequestNumber,
  }) {
    return PendingBuyRequestEntity(
      selectedBuyer: selectedBuyer ?? this.selectedBuyer,
      selectedSupplier: selectedSupplier ?? this.selectedSupplier,
      selectedEnterprises: selectedEnterprises ?? this.selectedEnterprises,
      selectedRequestType: selectedRequestType ?? this.selectedRequestType,
      products: products ?? this.products,
      lastSavedRequestNumber:
          lastSavedRequestNumber ?? this.lastSavedRequestNumber,
    );
  }

  PendingBuyRequestEntity annulValue({
    bool? annulSelectedBuyer,
    bool? annulSelectedSupplier,
    bool? annulSelectedEnterprises,
    bool? annulSelectedRequestType,
    bool? annulProducts,
    bool? annulLastSavedRequestNumber,
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
      products: annulProducts == true ? null : this.products,
      lastSavedRequestNumber: annulLastSavedRequestNumber == true
          ? null
          : this.lastSavedRequestNumber,
    );
  }

  factory PendingBuyRequestEntity.empty() => const PendingBuyRequestEntity(
    selectedBuyer: null,
    selectedSupplier: null,
    selectedEnterprises: null,
    selectedRequestType: null,
    products: null,
    lastSavedRequestNumber: null,
  );
}
