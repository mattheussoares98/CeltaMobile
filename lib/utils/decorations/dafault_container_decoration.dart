import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class DefaultContainerDecoration extends BoxDecoration {
  DefaultContainerDecoration(BuildContext context)
    : super(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.theme.colorScheme.outline.withAlpha(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      );
}
