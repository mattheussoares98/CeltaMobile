import 'package:equatable/equatable.dart';

import '../entities.dart';

class EnterpriseEntity extends Equatable {
  final String name;
  final int? id; //from supabase
  final List<SubEnterpriseEntity>? subEnterprises; //from supabase
  final String? remoteHttpUrl;
  final String? remoteHttpsUrl;
  final String? localHttpUrl;
  final String? localHttpsUrl;
  final String? workingUrl; //url that is working after check the urls provided
  final int? Code; //from soap
  final String? PersonalizedCode; //from soap
  final String? CnpjNumber; //from soap
  final int? CodigoInternoVendaMobile_ModeloPedido; //from GetEnterprisesJson
  final int? ProductCodeSizeOfBalanceLabel; //from GetEnterprisesJson
  final bool? UseRetailSale; //from GetEnterprisesJson
  final bool? UseWholeSale; //from GetEnterprisesJson
  final bool? UseEcommerceSale; //from GetEnterprisesJson
  final bool? EnterpriseParticipateEnterpriseGroup; //from GetEnterprisesJson
  final bool? ProductCodeWithCheckerDigit; //from GetEnterprisesJson
  final String? InscriptionNumber; //from soap
  final int? SaleRequestTypeCode; //from GetEnterprisesJsonByFilters
  final String? FantasizesName; //from GetEnterprisesJsonByFilters

  const EnterpriseEntity({
    required this.name,
    this.id,
    this.subEnterprises,
    this.workingUrl,
    this.Code,
    this.PersonalizedCode,
    this.CnpjNumber,
    this.CodigoInternoVendaMobile_ModeloPedido,
    this.ProductCodeSizeOfBalanceLabel,
    this.UseRetailSale,
    this.UseWholeSale,
    this.UseEcommerceSale,
    this.EnterpriseParticipateEnterpriseGroup,
    this.ProductCodeWithCheckerDigit,
    this.InscriptionNumber,
    this.SaleRequestTypeCode,
    this.FantasizesName,
    this.remoteHttpUrl,
    this.remoteHttpsUrl,
    this.localHttpUrl,
    this.localHttpsUrl,
  });

  @override
  List<Object?> get props => [
    name,
    id,
    subEnterprises,
    workingUrl,
    Code,
    PersonalizedCode,
    CnpjNumber,
    CodigoInternoVendaMobile_ModeloPedido,
    ProductCodeSizeOfBalanceLabel,
    UseRetailSale,
    UseWholeSale,
    UseEcommerceSale,
    EnterpriseParticipateEnterpriseGroup,
    ProductCodeWithCheckerDigit,
    InscriptionNumber,
    SaleRequestTypeCode,
    FantasizesName,
    remoteHttpUrl,
    remoteHttpsUrl,
    localHttpUrl,
    localHttpsUrl,
  ];

  EnterpriseEntity copyWith({
    String? name,
    int? id,
    List<SubEnterpriseEntity>? subEnterprises,
    String? workingUrl,
    int? Code,
    String? PersonalizedCode,
    String? CnpjNumber,
    int? CodigoInternoVendaMobile_ModeloPedido,
    int? ProductCodeSizeOfBalanceLabel,
    bool? useRetailSale,
    bool? useWholeSale,
    bool? useEcommerceSale,
    bool? EnterpriseParticipateEnterpriseGroup,
    bool? ProductCodeWithCheckerDigit,
    String? InscriptionNumber,
    int? SaleRequestTypeCode,
    String? FantasizesName,
    String? remoteHttpUrl,
    String? remoteHttpsUrl,
    String? localHttpUrl,
    String? localHttpsUrl,
  }) {
    return EnterpriseEntity(
      name: name ?? this.name,
      id: id ?? this.id,
      subEnterprises: subEnterprises ?? this.subEnterprises,
      workingUrl: workingUrl ?? this.workingUrl,
      Code: Code ?? this.Code,
      PersonalizedCode: PersonalizedCode ?? this.PersonalizedCode,
      CnpjNumber: CnpjNumber ?? this.CnpjNumber,
      CodigoInternoVendaMobile_ModeloPedido:
          CodigoInternoVendaMobile_ModeloPedido ??
          this.CodigoInternoVendaMobile_ModeloPedido,
      ProductCodeSizeOfBalanceLabel:
          ProductCodeSizeOfBalanceLabel ?? this.ProductCodeSizeOfBalanceLabel,
      UseRetailSale: useRetailSale ?? this.UseRetailSale,
      UseWholeSale: useWholeSale ?? this.UseWholeSale,
      UseEcommerceSale: useEcommerceSale ?? this.UseEcommerceSale,
      EnterpriseParticipateEnterpriseGroup:
          EnterpriseParticipateEnterpriseGroup ??
          this.EnterpriseParticipateEnterpriseGroup,
      ProductCodeWithCheckerDigit:
          ProductCodeWithCheckerDigit ?? this.ProductCodeWithCheckerDigit,
      InscriptionNumber: InscriptionNumber ?? this.InscriptionNumber,
      SaleRequestTypeCode: SaleRequestTypeCode ?? this.SaleRequestTypeCode,
      FantasizesName: FantasizesName ?? this.FantasizesName,
      remoteHttpUrl: remoteHttpUrl ?? this.remoteHttpUrl,
      remoteHttpsUrl: remoteHttpsUrl ?? this.remoteHttpsUrl,
      localHttpUrl: localHttpUrl ?? this.localHttpUrl,
      localHttpsUrl: localHttpsUrl ?? this.localHttpsUrl,
    );
  }
}
