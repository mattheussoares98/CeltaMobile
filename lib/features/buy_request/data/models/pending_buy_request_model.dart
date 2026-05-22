import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';

class PendingBuyRequestModel extends Equatable {
  final BuyerModel? selectedBuyer;
  final SupplierModel? selectedSupplier;
  final BSFRequestTypeModel? selectedRequestType;
  final List<SoapEnterpriseByFiltersModel>? selectedEnterprises;
  final Map<ProductKey, BuyRequestProductItemModel>? products;
  final String? lastSavedRequestNumber;

  const PendingBuyRequestModel({
    required this.selectedBuyer,
    required this.selectedSupplier,
    required this.selectedEnterprises,
    required this.selectedRequestType,
    required this.products,
    required this.lastSavedRequestNumber,
  });

  @override
  List<Object?> get props => [
    selectedBuyer,
    selectedSupplier,
    selectedEnterprises,
    selectedRequestType,
    products,
    lastSavedRequestNumber,
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
          ? BSFRequestTypeModel.fromJson(json['selectedRequestType'])
          : null,
      selectedEnterprises: json['selectedEnterprises'] != null
          ? List<SoapEnterpriseByFiltersModel>.from(
              (json['selectedEnterprises'] as List).map(
                (x) => SoapEnterpriseByFiltersModel.fromJson(x),
              ),
            )
          : null,
      products: json['products'] == null
          ? null
          : Map.fromEntries(
              (json['products'] as Map).entries.map(
                (entry) => MapEntry(
                  ProductKey.fromMapKey(entry.key),
                  BuyRequestProductItemModel.fromJson(entry.value),
                ),
              ),
            ),
      lastSavedRequestNumber: json['lastSavedRequestNumber'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'selectedBuyer': selectedBuyer?.toJson(),
    'selectedSupplier': selectedSupplier?.toJson(),
    'selectedRequestType': selectedRequestType?.toJson(),
    'selectedEnterprises': selectedEnterprises?.map((e) => e.toJson()).toList(),
    'products': products == null
        ? null
        : Map.fromEntries(
            products!.entries.map(
              (entry) => MapEntry(entry.key.toMapKey(), entry.value.toJson()),
            ),
          ),
    'lastSavedRequestNumber': lastSavedRequestNumber,
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
      lastSavedRequestNumber: entity.lastSavedRequestNumber,
      selectedRequestType: entity.selectedRequestType == null
          ? null
          : BSFRequestTypeModel.fromEntity(entity.selectedRequestType!),
      products: entity.products == null
          ? null
          : Map.fromEntries(
              entity.products!.entries.map(
                (entry) => MapEntry(
                  entry.key,
                  BuyRequestProductItemModel.fromEntity(entry.value),
                ),
              ),
            ),
    );
  }

  PendingBuyRequestEntity toEntity() {
    return PendingBuyRequestEntity(
      selectedBuyer: selectedBuyer?.toEntity(),
      selectedSupplier: selectedSupplier?.toEntity(),
      selectedRequestType: selectedRequestType?.toEntity(),
      lastSavedRequestNumber: lastSavedRequestNumber,
      selectedEnterprises: selectedEnterprises
          ?.map((e) => e.toEntity())
          .toList(),
      products: products == null
          ? {}
          : Map.fromEntries(
              products!.entries.map(
                (entry) => MapEntry(entry.key, entry.value.toEntity()),
              ),
            ),
    );
  }
}
