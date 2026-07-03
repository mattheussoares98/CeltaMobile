import 'package:equatable/equatable.dart';

class BSFEnterpriseActivityEntity extends Equatable {
  final bool? isDistributionCenter;
  final bool? isCentralDeposit;
  final bool? isStore;
  final bool? isServices;

  const BSFEnterpriseActivityEntity({
    this.isDistributionCenter,
    this.isCentralDeposit,
    this.isStore,
    this.isServices,
  });

  @override
  List<Object?> get props => [
    isDistributionCenter,
    isCentralDeposit,
    isStore,
    isServices,
  ];
}
