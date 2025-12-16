// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

class BuyQuotationEnterpriseEntity extends Equatable {
  final int? Code;
  final BuyQuotationEnterpriseInfoEntity enterprise;

  const BuyQuotationEnterpriseEntity({
    required this.Code,
    required this.enterprise,
  });

  @override
  List<Object?> get props => [Code, enterprise];

  BuyQuotationEnterpriseEntity copyWith({
    int? Code,
    BuyQuotationEnterpriseInfoEntity? enterprise,
  }) {
    return BuyQuotationEnterpriseEntity(
      Code: Code ?? this.Code,
      enterprise: enterprise ?? this.enterprise,
    );
  }

  BuyQuotationEnterpriseEntity annulValues({bool? annulCode}) {
    return BuyQuotationEnterpriseEntity(
      Code: annulCode == true ? null : Code,
      enterprise: enterprise,
    );
  }
}

extension BuyQuotationEnterpriseEntityMapper on EnterpriseEntity {
  BuyQuotationEnterpriseEntity toBuyQuotationEnterprise() {
    return BuyQuotationEnterpriseEntity(
      Code: null,
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
