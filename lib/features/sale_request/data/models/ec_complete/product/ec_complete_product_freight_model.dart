import 'package:equatable/equatable.dart';

import '../ec_complete.dart';

class EcCompleteProductFreightModel extends Equatable {
  final EcCompleteValueTypeModel? discount;
  final EcCompleteValueTypeModel? increment;
  final double? value;

  const EcCompleteProductFreightModel({
    required this.discount,
    required this.increment,
    required this.value,
  });

  factory EcCompleteProductFreightModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteProductFreightModel(
        discount: json['Discount'] != null
            ? EcCompleteValueTypeModel.fromJson(json['Discount'])
            : null,
        increment: json['Increment'] != null
            ? EcCompleteValueTypeModel.fromJson(json['Increment'])
            : null,
        value: (json['Value'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'Discount': discount?.toJson(),
    'Increment': increment?.toJson(),
    'Value': value,
  };

  @override
  List<Object?> get props => [discount, increment, value];
}
