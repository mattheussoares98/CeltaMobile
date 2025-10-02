import 'package:equatable/equatable.dart';

class CovenantEntity extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String Name;

  const CovenantEntity({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [Code, PersonalizedCode, Name];
}
