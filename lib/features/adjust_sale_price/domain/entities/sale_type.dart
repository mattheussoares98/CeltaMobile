import '../../../../core/domain/entities/entities.dart';

enum SaleType implements SelectableCheckBoxItem {
  retail(1, 'Varejo'),
  whole(2, 'Atacado'),
  ecommerce(3, 'E-commerce');

  final int code;

  @override
  final String name;

  const SaleType(this.code, this.name);
}
