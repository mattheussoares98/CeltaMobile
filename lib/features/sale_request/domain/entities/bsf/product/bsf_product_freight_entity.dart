import 'package:equatable/equatable.dart';

import '../bsf.dart';

class BSFProductFreightEntity extends Equatable {
  final BSFValueTypeEntity? discount;
  final BSFValueTypeEntity? increment;
  final double? value;

  const BSFProductFreightEntity({
    required this.discount,
    required this.increment,
    required this.value,
  });

  @override
  List<Object?> get props => [discount, increment, value];
}
