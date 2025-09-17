import '../../../../core/domain/entities/entities.dart';

enum PriceType implements SelectableCheckBoxItem {
  sale('Venda'),
  offer('Oferta');

  @override
  final String name;
  const PriceType(this.name);
}
