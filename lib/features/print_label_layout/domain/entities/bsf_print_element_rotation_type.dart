import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:flutter/material.dart';

enum BSFPrintElementRotationType
    implements SelectableItem<BSFPrintElementRotationType> {
  none('None', '0°'),
  rotate90('Rotate90', '90°'),
  rotate180('Rotate180', '180°'),
  rotate270('Rotate270', '270°');

  final String apiValue;

  @override
  final String name;

  @override
  BSFPrintElementRotationType get value => this;

  @override
  Color? get color => null;

  const BSFPrintElementRotationType(this.apiValue, this.name);

  factory BSFPrintElementRotationType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () => throw FormatException('Invalid print rotation', value),
      );

  String toJson() => apiValue;
}
