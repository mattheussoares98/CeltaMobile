import 'package:flutter/material.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';

enum PriceType implements SelectableItem<PriceType> {
  sale('Venda'),
  offer('Oferta');

  @override
  final String name;

  @override
  PriceType get value => this;

  @override
  Color? get color => null;

  const PriceType(this.name);
}
