import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/customer/customer.dart';

class SoapCustomerCovenantModel extends Equatable {
  final SoapCovenantInfoModel? covenant;
  final String? Matriculate;
  final double? LimitOfPurchase;

  const SoapCustomerCovenantModel({
    required this.covenant,
    required this.Matriculate,
    required this.LimitOfPurchase,
  });

  @override
  List<Object?> get props => [covenant, Matriculate, LimitOfPurchase];

  factory SoapCustomerCovenantModel.fromJson(Map json) =>
      SoapCustomerCovenantModel(
        covenant: json['Covenant'] != null
            ? SoapCovenantInfoModel.fromJson(json['Covenant'])
            : null,
        Matriculate: json['Matriculate'],
        LimitOfPurchase: json['LimitOfPurchase'].toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Covenant': covenant?.toJson(),
    'Matriculate': Matriculate,
    'LimitOfPurchase': LimitOfPurchase,
  };

  factory SoapCustomerCovenantModel.fromEntity(CustomerCovenantEntity entity) =>
      SoapCustomerCovenantModel(
        covenant: entity.covenant != null
            ? SoapCovenantInfoModel.fromEntity(entity.covenant!)
            : null,
        Matriculate: entity.Matriculate,
        LimitOfPurchase: entity.LimitOfPurchase,
      );

  CustomerCovenantEntity toEntity() => CustomerCovenantEntity(
    covenant: covenant?.toEntity(),
    Matriculate: Matriculate,
    LimitOfPurchase: LimitOfPurchase,
  );
}
