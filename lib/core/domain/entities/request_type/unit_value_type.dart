import 'package:collection/collection.dart';

enum RequestUnitValueType {
  manual(0, 'Manual'),
  salePracticedRetail(1, 'Venda praticada varejo'),
  salePracticedWholeSale(2, 'Venda praticada atacado'),
  operationalCost(3, 'Custo operacional'),
  replacementCost(4, 'Custo reposição'),
  replacementCostMidle(5, 'Custo reposição médio'),
  liquidCost(6, 'Custo líquido'),
  liquidCostMidle(7, 'Custo líquido médio'),
  definedBySystem(8, 'Definido pelo sistema'),
  realCost(9, 'Custo real'),
  realLiquidCost(10, 'Custo líquido real'),
  fiscalCost(11, 'Custo fiscal'),
  fiscalLiquidCost(12, 'Custo líquido fiscal'),
  salePracticedECommerce(13, 'Venda praticada e-commerce');

  final int value;
  final String description;

  const RequestUnitValueType(this.value, this.description);

  static RequestUnitValueType? fromValue(int? value) {
    return RequestUnitValueType.values.firstWhereOrNull(
      (e) => e.value == value,
    );
  }
}
