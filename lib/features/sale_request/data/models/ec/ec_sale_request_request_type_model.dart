import 'package:equatable/equatable.dart';

class EcSaleRequestRequestTypeModel extends Equatable {
  final int Id;
  final String PersonalizedCode;
  final String Name;

  const EcSaleRequestRequestTypeModel({
    required this.Id,
    required this.PersonalizedCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [Id, PersonalizedCode, Name];
}
