// lib/features/buy_request/data/models/ec_buy_request_dto_model.dart

import 'package:celta_inventario/features/buy_request/data/models/ec_buy_request_dto/ec_buy_request_dto.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcBuyRequestDtoModel extends Equatable {
  final int? personalizedCode;
  final EcBuyRequestBuyerDtoModel? buyer;
  final EcBuyRequestTypeDtoModel? requestType;
  final EcBuyRequestSupplierDtoModel? supplier;
  final List<EcBuyRequestEnterpriseItemDtoModel>? enterprises;
  final double? totalLiquid;

  const EcBuyRequestDtoModel({
    required this.personalizedCode,
    required this.buyer,
    required this.requestType,
    required this.supplier,
    required this.enterprises,
    required this.totalLiquid,
  });

  @override
  List<Object?> get props => [
    personalizedCode,
    buyer,
    requestType,
    supplier,
    enterprises,
    totalLiquid,
  ];

  factory EcBuyRequestDtoModel.fromJson(Map json) {
    return EcBuyRequestDtoModel(
      personalizedCode: json['personalizedCode'] as int?,
      buyer: json['buyer'] != null
          ? EcBuyRequestBuyerDtoModel.fromJson(json['buyer'] as Map)
          : null,
      requestType: json['requestType'] != null
          ? EcBuyRequestTypeDtoModel.fromJson(json['requestType'] as Map)
          : null,
      supplier: json['supplier'] != null
          ? EcBuyRequestSupplierDtoModel.fromJson(json['supplier'] as Map)
          : null,
      enterprises: json['enterprises'] != null
          ? (json['enterprises'] as List)
                .map(
                  (e) => EcBuyRequestEnterpriseItemDtoModel.fromJson(e as Map),
                )
                .toList()
          : null,
      totalLiquid: (json['totalLiquid'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalizedCode': personalizedCode,
      'buyer': buyer?.toJson(),
      'requestType': requestType?.toJson(),
      'supplier': supplier?.toJson(),
      'enterprises': enterprises?.map((e) => e.toJson()).toList(),
      'totalLiquid': totalLiquid,
    };
  }

  factory EcBuyRequestDtoModel.fromEntity(EcBuyRequestDtoEntity entity) {
    return EcBuyRequestDtoModel(
      personalizedCode: entity.personalizedCode,
      buyer: entity.buyer != null
          ? EcBuyRequestBuyerDtoModel.fromEntity(entity.buyer!)
          : null,
      requestType: entity.requestType != null
          ? EcBuyRequestTypeDtoModel.fromEntity(entity.requestType!)
          : null,
      supplier: entity.supplier != null
          ? EcBuyRequestSupplierDtoModel.fromEntity(entity.supplier!)
          : null,
      enterprises: entity.enterprises
          ?.map((e) => EcBuyRequestEnterpriseItemDtoModel.fromEntity(e))
          .toList(),
      totalLiquid: entity.totalLiquid,
    );
  }

  EcBuyRequestDtoEntity toEntity() {
    return EcBuyRequestDtoEntity(
      personalizedCode: personalizedCode,
      buyer: buyer?.toEntity(),
      requestType: requestType?.toEntity(),
      supplier: supplier?.toEntity(),
      enterprises: enterprises?.map((e) => e.toEntity()).toList(),
      totalLiquid: totalLiquid,
    );
  }
}
