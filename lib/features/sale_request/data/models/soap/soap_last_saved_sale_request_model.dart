import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../models.dart';

class SoapLastSavedSaleRequestModel extends Equatable {
  final SoapPendingSaleRequestModel pendingSaleRequestModel;
  final String saleRequestNumber;

  const SoapLastSavedSaleRequestModel({
    required this.pendingSaleRequestModel,
    required this.saleRequestNumber,
  });

  @override
  List<Object?> get props => [pendingSaleRequestModel, saleRequestNumber];

  factory SoapLastSavedSaleRequestModel.fromJson(Map json) =>
      SoapLastSavedSaleRequestModel(
        pendingSaleRequestModel: SoapPendingSaleRequestModel.fromJson(
          json['pendingSaleRequestModel'],
        ),
        saleRequestNumber: json['saleRequestNumber'],
      );

  Map<String, dynamic> toJson() => {
    'pendingSaleRequestModel': pendingSaleRequestModel.toJson(),
    'saleRequestNumber': saleRequestNumber,
  };

  factory SoapLastSavedSaleRequestModel.fromEntity(
    LastSavedSaleRequestEntity entity,
  ) => SoapLastSavedSaleRequestModel(
    pendingSaleRequestModel: SoapPendingSaleRequestModel.fromEntity(
      entity.pendingSaleRequestEntity,
    ),
    saleRequestNumber: entity.saleRequestNumber,
  );

  LastSavedSaleRequestEntity toEntity() => LastSavedSaleRequestEntity(
    pendingSaleRequestEntity: pendingSaleRequestModel.toEntity(),
    saleRequestNumber: saleRequestNumber,
  );
}
