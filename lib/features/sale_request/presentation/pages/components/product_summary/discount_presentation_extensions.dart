import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';

extension BSFDiscountEntityPresentation on BSFDiscountEntity {
  String get formattedDescription {
    final value = discount!.value!.toString().toBrazilianNumber(2);
    final isPercentage = discount!.type == PercentageOrValue.percentage;
    final valueLabel = isPercentage ? '$value%' : 'R\$ $value';

    final origin = discountOrigin?.description ?? '';
    final justification = this.justification ?? '';

    final details = [
      if (origin.isNotEmpty) origin,
      if (justification.isNotEmpty) justification,
    ];

    if (details.isEmpty) {
      return valueLabel;
    }
    return '$valueLabel (${details.join(' - ')})';
  }
}

extension BSFDiscountListPresentation on List<BSFDiscountEntity>? {
  String? get formattedDescription {
    final activeDiscounts = this?.where((d) => (d.discount?.value ?? 0) > 0);
    if (activeDiscounts == null || activeDiscounts.isEmpty) return null;

    final buffer = StringBuffer();
    for (final d in activeDiscounts) {
      if (buffer.isNotEmpty) {
        buffer.write('\n');
      }
      buffer.write(d.formattedDescription);
    }
    return buffer.toString();
  }
}
