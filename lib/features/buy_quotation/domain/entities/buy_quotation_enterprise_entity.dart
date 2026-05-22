// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';

class BuyQuotationEnterpriseEntity extends Equatable {
  final int? Code;
  final BuyQuotationEnterpriseInfoEntity enterprise;
  final bool?
  isSelected; //local property to avoid loose the Code that receive from ERP

  const BuyQuotationEnterpriseEntity({
    required this.Code,
    required this.enterprise,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [Code, enterprise, isSelected];

  BuyQuotationEnterpriseEntity copyWith({
    int? Code,
    BuyQuotationEnterpriseInfoEntity? enterprise,
    bool? isSelected,
  }) {
    return BuyQuotationEnterpriseEntity(
      Code: Code ?? this.Code,
      isSelected: isSelected ?? this.isSelected,
      enterprise: enterprise ?? this.enterprise,
    );
  }

  BuyQuotationEnterpriseEntity annulValues({bool? annulCode}) {
    return BuyQuotationEnterpriseEntity(
      Code: annulCode == true ? null : Code,
      enterprise: enterprise,
      isSelected: isSelected,
    );
  }
}

extension BuyQuotationEnterpriseEntityMapper on EnterpriseEntity {
  BuyQuotationEnterpriseEntity toBuyQuotationEnterprise() {
    return BuyQuotationEnterpriseEntity(
      Code: null,
      isSelected: true,
      enterprise: BuyQuotationEnterpriseInfoEntity(
        PersonalizedCode: PersonalizedCode,
        Name: name,
        CnpjNumber: CnpjNumber,
        InscriptionNumber: InscriptionNumber,
        Code: Code,
      ),
    );
  }
}
