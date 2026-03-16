import 'package:equatable/equatable.dart';

class EcSellerModel extends Equatable {
  final int Id;
  final String Name;

  const EcSellerModel({required this.Id, required this.Name});

  @override
  List<Object?> get props => [Id, Name];
}
