import 'package:equatable/equatable.dart';

class BSFStateEntity extends Equatable {
  final String? acronym;
  final String? description;

  const BSFStateEntity({required this.acronym, required this.description});

  @override
  List<Object?> get props => [acronym, description];
}
