// lib/features/sale_request/data/models/bsf/bsf_driver_infos_model.dart
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class BSFDriverInfosModel extends BSFDriverInfosEntity {
  const BSFDriverInfosModel({
    required super.isDriver,
    required super.driverDocument,
    required super.driverDocumentExpiration,
    required super.driverCategory,
  });

  factory BSFDriverInfosModel.fromJson(Map<String, dynamic> json) =>
      BSFDriverInfosModel(
        isDriver: json['IsDriver'],
        driverDocument: json['DriverDocument'],
        driverDocumentExpiration: json['DriverDocumentExpiration'] != null
            ? DateTime.parse(json['DriverDocumentExpiration'])
            : null,
        driverCategory: json['DriverCategory'],
      );

  Map<String, dynamic> toJson() => {
        'IsDriver': isDriver,
        'DriverDocument': driverDocument,
        'DriverDocumentExpiration': driverDocumentExpiration?.toIso8601String(),
        'DriverCategory': driverCategory,
      };

  factory BSFDriverInfosModel.fromEntity(BSFDriverInfosEntity entity) =>
      BSFDriverInfosModel(
        isDriver: entity.isDriver,
        driverDocument: entity.driverDocument,
        driverDocumentExpiration: entity.driverDocumentExpiration,
        driverCategory: entity.driverCategory,
      );

  BSFDriverInfosEntity toEntity() => BSFDriverInfosEntity(
        isDriver: isDriver,
        driverDocument: driverDocument,
        driverDocumentExpiration: driverDocumentExpiration,
        driverCategory: driverCategory,
      );
}
