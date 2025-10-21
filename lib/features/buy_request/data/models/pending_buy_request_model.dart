import 'package:equatable/equatable.dart';

import '../../../../core/data/models/models.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class PendingBuyRequestModel extends Equatable {
  final BuyerModel? selectedBuyer;
  final SupplierModel? selectedSupplier;
  final RequestTypeModel? selectedRequestType;
  final List<SoapEnterpriseByFiltersModel>? selectedEnterprises;

  const PendingBuyRequestModel({
    required this.selectedBuyer,
    required this.selectedSupplier,
    required this.selectedEnterprises,
    required this.selectedRequestType,
  });

  @override
  List<Object?> get props => [
    selectedBuyer,
    selectedSupplier,
    selectedEnterprises,
    selectedRequestType,
  ];

  factory PendingBuyRequestModel.fromJson(Map json) {
    return PendingBuyRequestModel(
      selectedBuyer: json['selectedBuyer'] != null
          ? BuyerModel.fromJson(json['selectedBuyer'])
          : null,
      selectedSupplier: json['selectedSupplier'] != null
          ? SupplierModel.fromJson(json['selectedSupplier'])
          : null,
      selectedRequestType: json['selectedRequestType'] != null
          ? RequestTypeModel.fromJson(json['selectedRequestType'])
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
    'selectedRequestType': selectedRequestType?.toJson(),
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
      selectedRequestType: entity.selectedRequestType == null
          ? null
          : RequestTypeModel.fromEntity(entity.selectedRequestType!),
    );
  }

  PendingBuyRequestEntity toEntity() {
    return PendingBuyRequestEntity(
      selectedBuyer: selectedBuyer?.toEntity(),
      selectedSupplier: selectedSupplier?.toEntity(),
      selectedRequestType: selectedRequestType?.toEntity(),
      selectedEnterprises: selectedEnterprises
          ?.map((e) => e.toEntity())
          .toList(),
    );
  }
}
