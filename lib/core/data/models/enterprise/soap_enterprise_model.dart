import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class SoapEnterpriseModel extends Equatable {
  final int? Code;
  final String? PersonalizedCode;
  final String? Name;
  final String? CnpjNumber;
  final int? CodigoInternoVendaMobile_ModeloPedido;
  final bool? UseRetailSale;
  final bool? UseWholeSale;
  final bool? UseEcommerceSale;
  final bool? EnterpriseParticipateEnterpriseGroup;
  final int? ProductCodeSizeOfBalanceLabel;
  final bool? ProductCodeWithCheckerDigit;
  final String? InscriptionNumber;

  const SoapEnterpriseModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.CnpjNumber,
    required this.CodigoInternoVendaMobile_ModeloPedido,
    required this.UseEcommerceSale,
    required this.UseRetailSale,
    required this.UseWholeSale,
    required this.EnterpriseParticipateEnterpriseGroup,
    required this.ProductCodeSizeOfBalanceLabel,
    required this.ProductCodeWithCheckerDigit,
    required this.InscriptionNumber,
  });

  @override
  List<Object?> get props => [
    Code,
    PersonalizedCode,
    Name,
    CnpjNumber,
    CodigoInternoVendaMobile_ModeloPedido,
    UseEcommerceSale,
    UseRetailSale,
    UseWholeSale,
    EnterpriseParticipateEnterpriseGroup,
    ProductCodeSizeOfBalanceLabel,
    ProductCodeWithCheckerDigit,
    InscriptionNumber,
  ];

  factory SoapEnterpriseModel.fromJson(Map json) => SoapEnterpriseModel(
    Code: json["Code"],
    PersonalizedCode: json['PersonalizedCode'],
    Name: json['Name'],
    CnpjNumber: json['CnpjNumber'],
    UseEcommerceSale: json['SaleTypeECommerce'],
    UseRetailSale: json['SaleTypeRetail'],
    UseWholeSale: json['SaleTypeWholeSale'],
    CodigoInternoVendaMobile_ModeloPedido: json["SaleRequestTypeCode"],
    EnterpriseParticipateEnterpriseGroup:
        json["EnterpriseParticipateEnterpriseGroup"],
    ProductCodeSizeOfBalanceLabel: json["ProductCodeSizeOfBalanceLabel"],
    ProductCodeWithCheckerDigit: json["ProductCodeWithCheckerDigit"],
    InscriptionNumber: json["InscriptionNumber"],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'PersonalizedCode': PersonalizedCode,
    'Name': Name,
    'CnpjNumber': CnpjNumber,
    'SaleTypeECommerce': UseEcommerceSale,
    'SaleTypeRetail': UseRetailSale,
    'SaleTypeWholeSale': UseWholeSale,
    'SaleRequestTypeCode': CodigoInternoVendaMobile_ModeloPedido,
    'EnterpriseParticipateEnterpriseGroup':
        EnterpriseParticipateEnterpriseGroup,
    'ProductCodeSizeOfBalanceLabel': ProductCodeSizeOfBalanceLabel,
    'ProductCodeWithCheckerDigit': ProductCodeWithCheckerDigit,
    'InscriptionNumber': InscriptionNumber,
  };

  factory SoapEnterpriseModel.fromEntity(EnterpriseEntity entity) =>
      SoapEnterpriseModel(
        Code: entity.Code,
        PersonalizedCode: entity.PersonalizedCode,
        Name: entity.name,
        CnpjNumber: entity.CnpjNumber,
        CodigoInternoVendaMobile_ModeloPedido:
            entity.CodigoInternoVendaMobile_ModeloPedido,
        UseEcommerceSale: entity.UseEcommerceSale,
        UseRetailSale: entity.UseRetailSale,
        UseWholeSale: entity.UseWholeSale,
        EnterpriseParticipateEnterpriseGroup:
            entity.EnterpriseParticipateEnterpriseGroup,
        ProductCodeSizeOfBalanceLabel: entity.ProductCodeSizeOfBalanceLabel,
        ProductCodeWithCheckerDigit: entity.ProductCodeWithCheckerDigit,
        InscriptionNumber: entity.InscriptionNumber,
      );

  EnterpriseEntity toEntity() => EnterpriseEntity(
    name: Name ?? '',
    Code: Code,
    PersonalizedCode: PersonalizedCode,
    CnpjNumber: CnpjNumber,
    CodigoInternoVendaMobile_ModeloPedido:
        CodigoInternoVendaMobile_ModeloPedido,
    UseRetailSale: UseRetailSale,
    UseWholeSale: UseWholeSale,
    UseEcommerceSale: UseEcommerceSale,
    EnterpriseParticipateEnterpriseGroup: EnterpriseParticipateEnterpriseGroup,
    ProductCodeSizeOfBalanceLabel: ProductCodeSizeOfBalanceLabel,
    ProductCodeWithCheckerDigit: ProductCodeWithCheckerDigit,
    InscriptionNumber: InscriptionNumber,
  );
}
