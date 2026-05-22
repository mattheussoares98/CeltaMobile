import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFPaymentFormModel extends BSFPaymentFormEntity {
  const BSFPaymentFormModel({super.type, super.reducedName, super.name});

  @override
  List<Object?> get props => [type, reducedName, name];

  factory BSFPaymentFormModel.fromJson(Map<String, dynamic> json) =>
      BSFPaymentFormModel(
        type: PaymentFormType.fromValue(json['Type']),
        reducedName: json['ReducedName'],
        name: json['Name'],
      );

  Map<String, dynamic> toJson() => {
    'Type': type?.value,
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
