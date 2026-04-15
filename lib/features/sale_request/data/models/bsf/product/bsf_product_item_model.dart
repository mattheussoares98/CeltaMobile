import '../../../../domain/entities/entities.dart';
import '../bsf.dart';

class BSFProductItemModel extends BSFProductItemEntity {
  const BSFProductItemModel({
    required super.product,
    required super.fiscalCode,
    required super.compositionChilds,
    required super.eanCode,
    required super.freight,
    required super.discounts,
    required super.expectedDeliveryDate,
    required super.deliveryTax,
    required super.increment,
    required super.creditOnOrigin,
    required super.compensation,
    required super.quantity,
    required super.value,
    required super.code,
    required super.icms,
    required super.ipi,
  });

  factory BSFProductItemModel.fromJson(Map<String, dynamic> json) =>
      BSFProductItemModel(
        code: json['Code'],
        icms: json['Icms'] != null ? BSFIcmsModel.fromJson(json['Icms']) : null,
        ipi: json['Ipi'] != null ? BSFIpiModel.fromJson(json['Ipi']) : null,
        product: json['Product'] != null
            ? BSFProductDetailsModel.fromJson(json['Product'])
            : null,
        fiscalCode: json['FiscalCode'] != null
            ? BSFFiscalCodeModel.fromJson(json['FiscalCode'])
            : null,
        compositionChilds: json['CompositionChilds'],
        eanCode: json['EanCode'],
        freight: json['Freight'] != null
            ? (BSFProductFreightModel.fromJson(json['Freight'])
                  as BSFProductFreightEntity)
            : null,
        discounts: json['Discounts'] != null
            ? (json['Discounts'] as List)
                  .map((i) => BSFDiscountModel.fromJson(i))
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
    'Product': product != null
        ? BSFProductDetailsModel.fromEntity(product!).toJson()
        : null,
    'FiscalCode': fiscalCode != null
        ? BSFFiscalCodeModel.fromEntity(fiscalCode!).toJson()
        : null,
    'CompositionChilds': compositionChilds,
    'EanCode': eanCode,
    'Freight': freight != null
        ? BSFProductFreightModel.fromEntity(freight!).toJson()
        : null,
    'Discounts': discounts
        ?.map((e) => BSFDiscountModel.fromEntity(e).toJson())
        .toList(),
    'ExpectedDeliveryDate': expectedDeliveryDate?.toIso8601String(),
    'DeliveryTax': deliveryTax != null
        ? BSFValueTypeModel.fromEntity(deliveryTax!).toJson()
        : null,
    'Increment': increment != null
        ? BSFValueTypeModel.fromEntity(increment!).toJson()
        : null,
    'CreditOnOrigin': creditOnOrigin != null
        ? BSFValueTypeModel.fromEntity(creditOnOrigin!).toJson()
        : null,
    'Compensation': compensation != null
        ? BSFValueTypeModel.fromEntity(compensation!).toJson()
        : null,
    'Quantity': quantity,
    'Value': value,
    'Code': code,
    'Icms': icms != null ? BSFIcmsModel.fromEntity(icms!).toJson() : null,
    'Ipi': ipi != null ? BSFIpiModel.fromEntity(ipi!).toJson() : null,
  };

  factory BSFProductItemModel.fromEntity(BSFProductItemEntity entity) =>
      BSFProductItemModel(
        icms: entity.icms,
        ipi: entity.ipi,
        code: entity.code,
        product: entity.product,
        fiscalCode: entity.fiscalCode,
        compositionChilds: entity.compositionChilds,
        eanCode: entity.eanCode,
        freight: entity.freight,
        discounts: entity.discounts,
        expectedDeliveryDate: entity.expectedDeliveryDate,
        deliveryTax: entity.deliveryTax,
        increment: entity.increment,
        creditOnOrigin: entity.creditOnOrigin,
        compensation: entity.compensation,
        quantity: entity.quantity,
        value: entity.value,
      );

  BSFProductItemEntity toEntity() => BSFProductItemEntity(
    code: code,
    icms: icms,
    ipi: ipi,
    product: product,
    fiscalCode: fiscalCode,
    compositionChilds: compositionChilds,
    eanCode: eanCode,
    freight: freight,
    discounts: discounts,
    expectedDeliveryDate: expectedDeliveryDate,
    deliveryTax: deliveryTax,
    increment: increment,
    creditOnOrigin: creditOnOrigin,
    compensation: compensation,
    quantity: quantity,
    value: value,
  );
}
