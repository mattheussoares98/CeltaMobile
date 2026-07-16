import 'package:equatable/equatable.dart';

class BSFGRGroupEntity extends Equatable {
  final int? code;
  final String personalizedCode;

  const BSFGRGroupEntity({required this.code, required this.personalizedCode});

  @override
  List<Object?> get props => [code, personalizedCode];
}
