import 'package:equatable/equatable.dart';

import '../../../../core/data/models/models.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class PendingBuyRequestModel extends Equatable {
  final BuyerModel? selectedBuyer;
  final SupplierModel? selectedSupplier;
  final List<SoapEnterpriseByFiltersModel>? selectedEnterprises;

  const PendingBuyRequestModel({
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

  factory PendingBuyRequestModel.fromJson(Map json) {
    return PendingBuyRequestModel(
      selectedBuyer: json['selectedBuyer'] != null
          ? BuyerModel.fromJson(json['selectedBuyer'])
          : null,
      selectedSupplier: json['selectedSupplier'] != null
          ? SupplierModel.fromJson(json['selectedSupplier'])
          : null,
      selectedEnterprises: json['selectedEnterprises'] != null
          ? List<SoapEnterpriseByFiltersModel>.from(
              (json['selectedEnterprises'] as List).map(
                (x) => SoapEnterpriseByFiltersModel.fromJson(x),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'selectedBuyer': selectedBuyer?.toJson(),
    'selectedSupplier': selectedSupplier?.toJson(),
    'selectedEnterprises': selectedEnterprises?.map((e) => e.toJson()).toList(),
  };

  factory PendingBuyRequestModel.fromEntity(PendingBuyRequestEntity entity) {
    return PendingBuyRequestModel(
      selectedBuyer: entity.selectedBuyer == null
          ? null
          : BuyerModel.fromEntity(entity.selectedBuyer!),
      selectedSupplier: entity.selectedSupplier == null
          ? null
          : SupplierModel.fromEntity(entity.selectedSupplier!),
      selectedEnterprises: entity.selectedEnterprises
          ?.map((e) => SoapEnterpriseByFiltersModel.fromEntity(e))
          .toList(),
    );
  }

  PendingBuyRequestEntity toEntity() {
    return PendingBuyRequestEntity(
      selectedBuyer: selectedBuyer?.toEntity(),
      selectedSupplier: selectedSupplier?.toEntity(),
      selectedEnterprises: selectedEnterprises
          ?.map((e) => e.toEntity())
          .toList(),
    );
  }
}
