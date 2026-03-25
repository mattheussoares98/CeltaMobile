import 'package:equatable/equatable.dart';

import '../ec_complete.dart';

class EcCompleteProductItemModel extends Equatable {
  final EcCompleteProductDetailsModel? product;
  final dynamic compositionChilds;
  final String? eanCode;
  final EcCompleteProductFreightModel? freight;
  final List<EcCompleteProductDiscountModel>? discounts;
  final DateTime? expectedDeliveryDate;
  final EcCompleteValueTypeModel? deliveryTax;
  final EcCompleteValueTypeModel? increment;
  final EcCompleteValueTypeModel? creditOnOrigin;
  final EcCompleteValueTypeModel? compensation;
  final double? quantity;
  final double? value;

  const EcCompleteProductItemModel({
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

  factory EcCompleteProductItemModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteProductItemModel(
        product: json['Product'] != null
            ? EcCompleteProductDetailsModel.fromJson(json['Product'])
            : null,
        compositionChilds: json['CompositionChilds'],
        eanCode: json['EanCode'],
        freight: json['Freight'] != null
            ? EcCompleteProductFreightModel.fromJson(json['Freight'])
            : null,
        discounts: json['Discounts'] != null
            ? (json['Discounts'] as List)
                  .map((i) => EcCompleteProductDiscountModel.fromJson(i))
                  .toList()
            : null,
        expectedDeliveryDate: json['ExpectedDeliveryDate'] != null
            ? DateTime.parse(json['ExpectedDeliveryDate'])
            : null,
        deliveryTax: json['DeliveryTax'] != null
            ? EcCompleteValueTypeModel.fromJson(json['DeliveryTax'])
            : null,
        increment: json['Increment'] != null
            ? EcCompleteValueTypeModel.fromJson(json['Increment'])
            : null,
        creditOnOrigin: json['CreditOnOrigin'] != null
            ? EcCompleteValueTypeModel.fromJson(json['CreditOnOrigin'])
            : null,
        compensation: json['Compensation'] != null
            ? EcCompleteValueTypeModel.fromJson(json['Compensation'])
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
