import 'package:equatable/equatable.dart';

class BuyQuotationEnterpriseInfoEntity extends Equatable {
  final String? PersonalizedCode;
  final String? Name;
  final String? CnpjNumber;
  final String? InscriptionNumber;
  final int? Code;

  const BuyQuotationEnterpriseInfoEntity({
    required this.PersonalizedCode,
    required this.Name,
    required this.CnpjNumber,
    required this.InscriptionNumber,
    required this.Code,
  });

  @override
  List<Object?> get props => [
    PersonalizedCode,
    Name,
    CnpjNumber,
    InscriptionNumber,
    Code,
  ];
}
