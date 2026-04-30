import 'package:flutter/material.dart';

import '../../../../../../../localization/string_hardcoded.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final bool isPrice;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.isPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(
          isPrice ? 'R\$ $value'.hardcoded : value,
          style: valueStyle,
        ),
      ],
    );
  }
}
