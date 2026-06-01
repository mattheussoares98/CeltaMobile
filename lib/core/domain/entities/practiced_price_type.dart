import 'package:collection/collection.dart';

enum PracticedPriceType {
  manual(0, 'Manual', 'M'),
  retail(1, 'Varejo', 'V'),
  whole(2, 'Atacado', 'A'),
  operationalCost(3, 'Custo operacional', 'CO'),
  replacementCost(4, 'Custo reposição', 'CR'),
  replacementCostMidle(5, 'Custo reposição médio', 'CRM'),
  liquidCost(6, 'Custo líquido', 'CL'),
  liquidCostMidle(7, 'Custo líquido médio', 'CLM'),
  definedBySystem(8, 'Definido pelo sistema', 'DS'),
  realCost(9, 'Custo real', 'RC'),
  realLiquidCost(10, 'Custo líquido real', 'CLR'),
  fiscalCost(11, 'Custo fiscal', 'CF'),
  fiscalLiquidCost(12, 'Custo líquido fiscal', 'CLF'),
  ecommerce(13, 'E-commerce', 'E');

  final int value;
  final String description;
  final String abbreviation;

  const PracticedPriceType(this.value, this.description, this.abbreviation);

  static PracticedPriceType? fromValue(int? value) {
    return PracticedPriceType.values.firstWhereOrNull((e) => e.value == value);
  }
}
