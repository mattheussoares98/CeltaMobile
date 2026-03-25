import 'package:equatable/equatable.dart';

import '../bsf.dart';

class BSFProductItemModel extends Equatable {
  final BSFProductDetailsModel? product;
  final dynamic compositionChilds;
  final String? eanCode;
  final BSFProductFreightModel? freight;
  final List<BSFProductDiscountModel>? discounts;
  final DateTime? expectedDeliveryDate;
  final BSFValueTypeModel? deliveryTax;
  final BSFValueTypeModel? increment;
  final BSFValueTypeModel? creditOnOrigin;
  final BSFValueTypeModel? compensation;
  final double? quantity;
  final double? value;

  const BSFProductItemModel({
    required this.product,
    required this.compositionChilds,
    required this.eanCode,
    required this.freight,
    required this.discounts,
    required this.expectedDeliveryDate,
    required this.deliveryTax,
    required this.increment,
    required this.creditOnOrigin,
    required this.compensation,
    required this.quantity,
    required this.value,
  });

  factory BSFProductItemModel.fromJson(Map<String, dynamic> json) =>
      BSFProductItemModel(
        product: json['Product'] != null
            ? BSFProductDetailsModel.fromJson(json['Product'])
            : null,
        compositionChilds: json['CompositionChilds'],
        eanCode: json['EanCode'],
        freight: json['Freight'] != null
            ? BSFProductFreightModel.fromJson(json['Freight'])
            : null,
        discounts: json['Discounts'] != null
            ? (json['Discounts'] as List)
                  .map((i) => BSFProductDiscountModel.fromJson(i))
                  .toList()
            : null,
        expectedDeliveryDate: json['ExpectedDeliveryDate'] != null
            ? DateTime.parse(json['ExpectedDeliveryDate'])
            : null,
        deliveryTax: json['DeliveryTax'] != null
            ? BSFValueTypeModel.fromJson(json['DeliveryTax'])
            : null,
        increment: json['Increment'] != null
            ? BSFValueTypeModel.fromJson(json['Increment'])
            : null,
        creditOnOrigin: json['CreditOnOrigin'] != null
            ? BSFValueTypeModel.fromJson(json['CreditOnOrigin'])
            : null,
        compensation: json['Compensation'] != null
            ? BSFValueTypeModel.fromJson(json['Compensation'])
            : null,
        quantity: (json['Quantity'] as num?)?.toDouble(),
        value: (json['Value'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'Product': product?.toJson(),
    'CompositionChilds': compositionChilds,
    'EanCode': eanCode,
    'Freight': freight?.toJson(),
    'Discounts': discounts?.map((e) => e.toJson()).toList(),
    'ExpectedDeliveryDate': expectedDeliveryDate?.toIso8601String(),
    'DeliveryTax': deliveryTax?.toJson(),
    'Increment': increment?.toJson(),
    'CreditOnOrigin': creditOnOrigin?.toJson(),
    'Compensation': compensation?.toJson(),
    'Quantity': quantity,
    'Value': value,
  };

  @override
  List<Object?> get props => [product, quantity, value];
}
