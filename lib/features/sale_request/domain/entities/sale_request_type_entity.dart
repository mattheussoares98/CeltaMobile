import 'package:equatable/equatable.dart';

class SaleRequestRequestTypeEntity extends Equatable {
  final int Id;
  final String PersonalizedCode;
  final String Name;

  const SaleRequestRequestTypeEntity({
    required this.Id,
    required this.PersonalizedCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [Id, PersonalizedCode, Name];
}
