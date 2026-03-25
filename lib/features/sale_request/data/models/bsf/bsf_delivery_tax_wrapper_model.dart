import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [deliveryTax, isFob];
}
