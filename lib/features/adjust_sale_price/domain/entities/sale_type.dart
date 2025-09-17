import '../../../../commom_widgets/commom_widgets.dart';

enum SaleType implements SelectableItem {
  retail(1, 'Varejo'),
  whole(2, 'Atacado'),
  ecommerce(3, 'E-commerce');

  final int code;

  @override
  final String name;

  const SaleType(this.code, this.name);
}
