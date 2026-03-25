import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'bsf.dart';

class BSFDeliveryTaxWrapperModel extends Equatable {
  final BSFValueTypeModel? deliveryTax;
  final dynamic mailFreightType;
  final bool? isFob;
  final bool? isDiscounted;

  const BSFDeliveryTaxWrapperModel({
    required this.deliveryTax,
    required this.mailFreightType,
    required this.isFob,
    required this.isDiscounted,
  });

  @override
  List<Object?> get props => [
    deliveryTax,
    mailFreightType,
    isFob,
    isDiscounted,
  ];

  factory BSFDeliveryTaxWrapperModel.fromJson(Map<String, dynamic> json) =>
      BSFDeliveryTaxWrapperModel(
        deliveryTax: json['DeliveryTax'] != null
            ? BSFValueTypeModel.fromJson(json['DeliveryTax'])
            : null,
        mailFreightType: json['MailFreightType'],
        isFob: json['IsFob'],
        isDiscounted: json['IsDiscounted'],
      );

  Map<String, dynamic> toJson() => {
    'DeliveryTax': deliveryTax?.toJson(),
    'MailFreightType': mailFreightType,
    'IsFob': isFob,
    'IsDiscounted': isDiscounted,
  };

  factory BSFDeliveryTaxWrapperModel.fromEntity(
    BSFDeliveryTaxWrapperEntity entity,
  ) => BSFDeliveryTaxWrapperModel(
    deliveryTax: entity.deliveryTax == null
        ? null
        : BSFValueTypeModel.fromEntity(entity.deliveryTax!),
    mailFreightType: entity.mailFreightType,
    isFob: entity.isFob,
    isDiscounted: entity.isDiscounted,
  );

  BSFDeliveryTaxWrapperEntity toEntity() => BSFDeliveryTaxWrapperEntity(
    deliveryTax: deliveryTax?.toEntity(),
    mailFreightType: mailFreightType,
    isFob: isFob,
    isDiscounted: isDiscounted,
  );
}
