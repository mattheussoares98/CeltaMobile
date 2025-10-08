import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'customer.dart';

class CustomerCovenantModel extends Equatable {
  final CovenantInfoModel? covenant;
  final String? Matriculate;
  final double? LimitOfPurchase;

  const CustomerCovenantModel({
    required this.covenant,
    required this.Matriculate,
    required this.LimitOfPurchase,
  });

  @override
  List<Object?> get props => [covenant, Matriculate, LimitOfPurchase];

  factory CustomerCovenantModel.fromJson(Map json) => CustomerCovenantModel(
    covenant: json['Covenant'] != null
        ? CovenantInfoModel.fromJson(json['Covenant'])
        : null,
    Matriculate: json['Matriculate'],
    LimitOfPurchase: json['LimitOfPurchase'].toDouble(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Covenant': covenant?.toJson(),
    'Matriculate': Matriculate,
    'LimitOfPurchase': LimitOfPurchase,
  };

  factory CustomerCovenantModel.fromEntity(CustomerCovenantEntity entity) =>
      CustomerCovenantModel(
        covenant: entity.covenant != null
            ? CovenantInfoModel.fromEntity(entity.covenant!)
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
