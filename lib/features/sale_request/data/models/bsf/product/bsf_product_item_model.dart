import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';
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

  @override
  List<Object?> get props => [
    product,
    compositionChilds,
    eanCode,
    freight,
    discounts,
    expectedDeliveryDate,
    deliveryTax,
    increment,
    creditOnOrigin,
    compensation,
    quantity,
    value,
  ];

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

  factory BSFProductItemModel.fromEntity(BSFProductItemEntity entity) =>
      BSFProductItemModel(
        product: entity.product == null
            ? null
            : BSFProductDetailsModel.fromEntity(entity.product!),
        compositionChilds: entity.compositionChilds,
        eanCode: entity.eanCode,
        freight: entity.freight == null
            ? null
            : BSFProductFreightModel.fromEntity(entity.freight!),
        discounts: entity.discounts == null
            ? null
            : (entity.discounts!)
                  .map((e) => BSFProductDiscountModel.fromEntity(e))
                  .toList(),
        expectedDeliveryDate: entity.expectedDeliveryDate,
        deliveryTax: entity.deliveryTax == null
            ? null
            : BSFValueTypeModel.fromEntity(entity.deliveryTax!),
        increment: entity.increment == null
            ? null
            : BSFValueTypeModel.fromEntity(entity.increment!),
        creditOnOrigin: entity.creditOnOrigin == null
            ? null
            : BSFValueTypeModel.fromEntity(entity.creditOnOrigin!),
        compensation: entity.compensation == null
            ? null
            : BSFValueTypeModel.fromEntity(entity.compensation!),
        quantity: entity.quantity,
        value: entity.value,
      );

  BSFProductItemEntity toEntity() => BSFProductItemEntity(
    product: product?.toEntity(),
    compositionChilds: compositionChilds,
    eanCode: eanCode,
    freight: freight?.toEntity(),
    discounts: discounts?.map((e) => e.toEntity()).toList(),
    expectedDeliveryDate: expectedDeliveryDate,
    deliveryTax: deliveryTax?.toEntity(),
    increment: increment?.toEntity(),
    creditOnOrigin: creditOnOrigin?.toEntity(),
    compensation: compensation?.toEntity(),
    quantity: quantity,
    value: value,
  );
}
