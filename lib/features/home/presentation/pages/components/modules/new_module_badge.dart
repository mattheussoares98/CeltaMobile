import 'package:flutter/material.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';

class NewModuleBadge extends StatelessWidget {
  const NewModuleBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      top: 0,
      left: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Sizes.p8),
          bottomRight: Radius.circular(Sizes.p8),
        ),
        child: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.p4,
            horizontal: Sizes.p16,
          ),
          child: Text(
            'Novo'.hardcoded,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
