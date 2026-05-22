import 'package:flutter/material.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

enum SaleType implements SelectableItem<SaleType> {
  retail(1, 'Varejo'),
  whole(2, 'Atacado'),
  ecommerce(3, 'E-commerce');

  final int code;

  @override
  final String name;

  @override
  SaleType get value => this;

  @override
  Color? get color => null;

  const SaleType(this.code, this.name);
}
