import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrintLabelLayoutValueAdjuster extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  final Duration repeatInterval;

  const PrintLabelLayoutValueAdjuster({
    super.key,
    required this.label,
    required this.value,
    this.onDecrease,
    this.onIncrease,
    this.repeatInterval = const Duration(milliseconds: 75),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseText(label, overflow: TextOverflow.ellipsis),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: PrintLabelRepeatingIconButton(
                repeatInterval: repeatInterval,
                onPressed: onDecrease,
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.minus_circle,
                  materialIcon: Icons.remove_circle_outline,
                ),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(Sizes.p4),
                constraints: const BoxConstraints(),
              ),
            ),
            gapW4,
            FittedBox(child: BaseText(value, overflow: TextOverflow.ellipsis)),
            gapW4,
            Flexible(
              child: PrintLabelRepeatingIconButton(
                repeatInterval: repeatInterval,
                onPressed: onIncrease,
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.plus_circle,
                  materialIcon: Icons.add_circle_outline,
                ),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(Sizes.p4),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
