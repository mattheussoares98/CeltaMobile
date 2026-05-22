import 'package:flutter/services.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

enum PercentageOrValue implements SelectableItem<PercentageOrValue> {
  percentage('%', 'Porcentagem', 1),
  reais('R\$', 'Reais', 2);

  final String symbol;
  @override
  final String name;
  final int code;
  @override
  PercentageOrValue get value => this;

  const PercentageOrValue(this.symbol, this.name, this.code);

  @override
  Color? get color => null;
}
