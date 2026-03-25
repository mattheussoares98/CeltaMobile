import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class BSFValueTypeEntity extends Equatable {
  final PercentageOrValue? type;
  final double? value;

  const BSFValueTypeEntity({required this.type, required this.value});

  @override
  List<Object?> get props => [type, value];
}
