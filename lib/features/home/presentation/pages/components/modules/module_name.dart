import 'package:flutter/material.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../routing/routing.dart';

class ModuleName extends StatelessWidget {
  const ModuleName({super.key, required this.route});

  final Routes route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Text(
        route.module,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
