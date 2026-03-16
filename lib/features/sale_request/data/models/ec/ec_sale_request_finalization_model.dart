import 'package:equatable/equatable.dart';

class EcSaleRequestFinalizationModel extends Equatable {
  final String Id;
  final String Name;
  final double TotalValue;
  final int PortionQuantity;

  const EcSaleRequestFinalizationModel({
    required this.Id,
    required this.Name,
    required this.TotalValue,
    required this.PortionQuantity,
  });

  @override
  List<Object?> get props => [Id, Name, TotalValue, PortionQuantity];
}
