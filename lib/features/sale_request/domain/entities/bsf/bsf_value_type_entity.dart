import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class BSFValueTypeEntity extends Equatable {
  final PercentageOrValue? type;
  final double? value;

  const BSFValueTypeEntity({required this.type, required this.value});

  @override
  List<Object?> get props => [type, value];
}

extension BSFValueTypeEntityExtension on BSFValueTypeEntity {
  double calculateItemValue(double? price) {
    if (value == null || value == 0) return 0;
    if (price == null || price == 0) return 0;
    if (type == null) return 0;

    return price -
        (type == PercentageOrValue.value
            ? value!
            : price * (1 - (value! / 100)));
  }
}
