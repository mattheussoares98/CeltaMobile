import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class SummaryTooltip extends StatelessWidget {
  final String? message;
  final String? text;
  final Color? color;

  const SummaryTooltip({
    super.key,
    required this.message,
    this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.width <= 200 || (message?.isEmpty ?? true)) {
      return const SizedBox.shrink();
    }

    final displayText = (text == null || text!.isEmpty) ? 'i' : text!;
    final effectiveColor = color ?? context.theme.primaryColor;

    return Tooltip(
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 3),
      waitDuration: const Duration(milliseconds: 10),
      child: Container(
        padding: const EdgeInsets.all(Sizes.p4),
        decoration: BoxDecoration(
          color: effectiveColor.withAlpha(30),
          borderRadius: BorderRadius.circular(Sizes.p4),
        ),
        child: Text(
          '  $displayText  ',
          style: context.theme.textTheme.labelSmall?.copyWith(
            color: effectiveColor,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
