import 'package:flutter/material.dart';
import '../../../../core/domain/entities/entities.dart';

enum PriceType implements SelectableItem<PriceType> {
  sale('Varejo'),
  offer('Oferta');

  @override
  final String name;

  @override
  PriceType get value => this;

  @override
  Color? get color => null;

  const PriceType(this.name);
}
