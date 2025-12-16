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
}

extension BuyQuotationEnterpriseEntityMapper on EnterpriseEntity {
  BuyQuotationEnterpriseEntity toBuyQuotationEnterprise() {
    return BuyQuotationEnterpriseEntity(
      Code: null, //TODO check if works when unselect and select again
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
