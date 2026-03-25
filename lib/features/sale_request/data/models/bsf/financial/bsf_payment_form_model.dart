import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';

class BSFPaymentFormModel extends Equatable {
  final int? type;
  final String? reducedName;
  final String? name;

  const BSFPaymentFormModel({
    required this.type,
    required this.reducedName,
    required this.name,
  });

  @override
  List<Object?> get props => [type, reducedName, name];

  factory BSFPaymentFormModel.fromJson(Map<String, dynamic> json) =>
      BSFPaymentFormModel(
        type: json['Type'],
        reducedName: json['ReducedName'],
        name: json['Name'],
      );

  Map<String, dynamic> toJson() => {
    'Type': type,
    'ReducedName': reducedName,
    'Name': name,
  };
  factory BSFPaymentFormModel.fromEntity(BSFPaymentFormEntity entity) =>
      BSFPaymentFormModel(
        type: entity.type,
        reducedName: entity.reducedName,
        name: entity.name,
      );

  BSFPaymentFormEntity toEntity() =>
      BSFPaymentFormEntity(type: type, reducedName: reducedName, name: name);
}
