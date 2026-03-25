import 'package:equatable/equatable.dart';

import '../bsf.dart';

class BSFProductFreightModel extends Equatable {
  final BSFValueTypeModel? discount;
  final BSFValueTypeModel? increment;
  final double? value;

  const BSFProductFreightModel({
    required this.discount,
    required this.increment,
    required this.value,
  });

  factory BSFProductFreightModel.fromJson(Map<String, dynamic> json) =>
      BSFProductFreightModel(
        discount: json['Discount'] != null
            ? BSFValueTypeModel.fromJson(json['Discount'])
            : null,
        increment: json['Increment'] != null
            ? BSFValueTypeModel.fromJson(json['Increment'])
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
