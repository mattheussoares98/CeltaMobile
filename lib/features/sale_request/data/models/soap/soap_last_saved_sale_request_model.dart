import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';

class SoapLastSavedSaleRequestModel extends Equatable {
  final SoapSaleRequestModel saleRequestModel;
  final String saleRequestNumber;

  const SoapLastSavedSaleRequestModel({
    required this.saleRequestModel,
    required this.saleRequestNumber,
  });

  @override
  List<Object?> get props => [saleRequestModel, saleRequestNumber];

  factory SoapLastSavedSaleRequestModel.fromJson(Map json) =>
      SoapLastSavedSaleRequestModel(
        saleRequestModel: SoapSaleRequestModel.fromJson(
          json['saleRequestModel'],
        ),
        saleRequestNumber: json['saleRequestNumber'],
      );

  Map<String, dynamic> toJson() => {
    'saleRequestModel': saleRequestModel.toJson(),
    'saleRequestNumber': saleRequestNumber,
  };

  factory SoapLastSavedSaleRequestModel.fromEntity(
    LastSavedSaleRequestEntity entity,
  ) => SoapLastSavedSaleRequestModel(
    saleRequestModel: SoapSaleRequestModel.fromEntity(entity.saleRequestEntity),
    saleRequestNumber: entity.saleRequestNumber,
  );

  LastSavedSaleRequestEntity toEntity() => LastSavedSaleRequestEntity(
    saleRequestEntity: saleRequestModel.toEntity(),
    saleRequestNumber: saleRequestNumber,
  );
}
