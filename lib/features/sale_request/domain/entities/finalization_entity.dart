import 'package:equatable/equatable.dart';

class FinalizationEntity extends Equatable {
  final String Id;
  final String Name;
  final double TotalValue;
  final int PortionQuantity;

  const FinalizationEntity({
    required this.Id,
    required this.Name,
    required this.TotalValue,
    required this.PortionQuantity,
  });

  @override
  List<Object?> get props => [Id, Name, TotalValue, PortionQuantity];
}
