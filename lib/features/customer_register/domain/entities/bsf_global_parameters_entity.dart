import 'package:equatable/equatable.dart';

class BSFGlobalParametersEntity extends Equatable {
  final bool requiredCpfCnpjInCustomer;

  const BSFGlobalParametersEntity({required this.requiredCpfCnpjInCustomer});

  @override
  List<Object?> get props => [requiredCpfCnpjInCustomer];
}
