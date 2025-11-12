import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class LastSavedSaleRequestModel extends Equatable {
  final PendingSaleRequestModel pendingSaleRequestModel;
  final String saleRequestNumber;

  const LastSavedSaleRequestModel({
    required this.pendingSaleRequestModel,
    required this.saleRequestNumber,
  });

  @override
  List<Object?> get props => [pendingSaleRequestModel, saleRequestNumber];

  factory LastSavedSaleRequestModel.fromJson(Map json) =>
      LastSavedSaleRequestModel(
        pendingSaleRequestModel: PendingSaleRequestModel.fromJson(
          json['pendingSaleRequestModel'],
        ),
        saleRequestNumber: json['saleRequestNumber'],
      );

  Map<String, dynamic> toJson() => {
    'pendingSaleRequestModel': pendingSaleRequestModel.toJson(),
    'saleRequestNumber': saleRequestNumber,
  };

  factory LastSavedSaleRequestModel.fromEntity(
    LastSavedSaleRequestEntity entity,
  ) => LastSavedSaleRequestModel(
    pendingSaleRequestModel: PendingSaleRequestModel.fromEntity(
      entity.pendingSaleRequestEntity,
    ),
    saleRequestNumber: entity.saleRequestNumber,
  );

  LastSavedSaleRequestEntity toEntity() => LastSavedSaleRequestEntity(
    pendingSaleRequestEntity: pendingSaleRequestModel.toEntity(),
    saleRequestNumber: saleRequestNumber,
  );
}
