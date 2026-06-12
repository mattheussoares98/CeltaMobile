import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFValueTypeEntity extends Equatable {
  final PercentageOrValue? type;
  final double? value;

  const BSFValueTypeEntity({required this.type, required this.value});

  @override
  List<Object?> get props => [type, value];

  BSFValueTypeEntity copyWith({PercentageOrValue? type, double? value}) {
    return BSFValueTypeEntity(
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  double calculateItemValue(double? price) {
    if (value == null || value == 0) return 0;
    if (price == null || price == 0) return 0;
    if (type == null) return 0;

    final calculation = type == PercentageOrValue.reais
        ? value!
        : price * (value! / 100);

    return calculation;
  }
}
