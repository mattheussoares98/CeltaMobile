import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFGlobalParametersModel extends Equatable {
  final bool requiredCpfCnpjInCustomer;

  const BSFGlobalParametersModel({required this.requiredCpfCnpjInCustomer});

  factory BSFGlobalParametersModel.fromJson(Map json) =>
      BSFGlobalParametersModel(
        requiredCpfCnpjInCustomer: json['requiredCpfCnpjInCustomer'],
      );

  factory BSFGlobalParametersModel.fromEntity(
    BSFGlobalParametersEntity entity,
  ) => BSFGlobalParametersModel(
    requiredCpfCnpjInCustomer: entity.requiredCpfCnpjInCustomer,
  );

  Map toJson() => {'requiredCpfCnpjInCustomer': requiredCpfCnpjInCustomer};

  BSFGlobalParametersEntity toEntity() => BSFGlobalParametersEntity(
    requiredCpfCnpjInCustomer: requiredCpfCnpjInCustomer,
  );

  @override
  List<Object?> get props => [requiredCpfCnpjInCustomer];
}
