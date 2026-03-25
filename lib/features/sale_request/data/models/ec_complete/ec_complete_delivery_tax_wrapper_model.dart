import 'package:equatable/equatable.dart';

import 'ec_complete.dart';

class EcCompleteDeliveryTaxWrapperModel extends Equatable {
  final EcCompleteValueTypeModel? deliveryTax;
  final dynamic mailFreightType;
  final bool? isFob;
  final bool? isDiscounted;

  const EcCompleteDeliveryTaxWrapperModel({
    required this.deliveryTax,
    required this.mailFreightType,
    required this.isFob,
    required this.isDiscounted,
  });

  factory EcCompleteDeliveryTaxWrapperModel.fromJson(
    Map<String, dynamic> json,
  ) => EcCompleteDeliveryTaxWrapperModel(
    deliveryTax: json['DeliveryTax'] != null
        ? EcCompleteValueTypeModel.fromJson(json['DeliveryTax'])
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
