import 'package:equatable/equatable.dart';

class SellerEntity extends Equatable {
  final int Id;
  final String Name;

  const SellerEntity({required this.Id, required this.Name});

  @override
  List<Object?> get props => [Id, Name];
}
