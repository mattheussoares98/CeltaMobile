import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../domain/entities/entities.dart';

class IncrementField extends StatelessWidget {
  final TextEditingController controller;
  final PercentageOrValue type;
  final ValueChanged<PercentageOrValue> onTypeChanged;

  const IncrementField({
    super.key,
    required this.controller,
    required this.type,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acréscimo'.hardcoded,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        gapH8,
        Row(
          children: [
            Expanded(
              child: DefaultTextFormField(
                controller: controller,
                labelText: 'Valor'.hardcoded,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
            ),
            gapW8,
            SegmentedButton<PercentageOrValue>(
              segments: [
                ButtonSegment(
                  value: PercentageOrValue.reais,
                  label: Text('R\$'.hardcoded),
                ),
                ButtonSegment(
                  value: PercentageOrValue.percentage,
                  label: Text('%'.hardcoded),
                ),
              ],
              selected: {type},
              onSelectionChanged: (selected) {
                onTypeChanged(selected.first);
              },
            ),
          ],
        ),
      ],
    );
  }
}
