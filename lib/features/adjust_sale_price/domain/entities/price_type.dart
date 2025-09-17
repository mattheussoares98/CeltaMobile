import '../../../../commom_widgets/commom_widgets.dart';

enum PriceType implements SelectableItem {
  sale('Venda'),
  offer('Oferta');

  @override
  final String name;
  const PriceType(this.name);
}
