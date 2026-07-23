import 'package:equatable/equatable.dart';

class EcBuyMovementUserDtoEntity extends Equatable {
  final int? code;
  final String? name;

  const EcBuyMovementUserDtoEntity({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];
}
