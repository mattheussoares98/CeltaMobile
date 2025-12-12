import 'package:equatable/equatable.dart';

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
