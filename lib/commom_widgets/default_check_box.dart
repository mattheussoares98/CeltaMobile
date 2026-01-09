import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class DefaultCheckBox extends StatelessWidget {
  final String name;
  final bool enabled;
  final void Function(bool?)? onChanged;
  const DefaultCheckBox({
    super.key,
    required this.name,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    if (isIOS) {
      return CupertinoListTile(
        padding: EdgeInsets.zero,
        title: Text(name, style: theme.textTheme.bodyMedium),
        trailing: CupertinoSwitch(value: enabled, onChanged: onChanged),
      );
    } else {
      return CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
        title: Text(name, style: theme.textTheme.bodyMedium),
        value: enabled,
        onChanged: onChanged,
        dense: true,
      );
    }
  }
}
