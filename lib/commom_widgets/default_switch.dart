import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool)? onChanged;
  const DefaultSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleSmall;

    if (PlatformUtil.isCupertino) {
      return CupertinoListTile(
        title: Text(title, style: textStyle),
        padding: EdgeInsets.zero,
        trailing: CupertinoSwitch(value: value, onChanged: onChanged),
      );
    } else {
      return SwitchListTile.adaptive(
        dense: true,
        contentPadding: EdgeInsetsGeometry.zero,
        title: Text(title, style: textStyle),
        value: value,
        onChanged: onChanged,
      );
    }
  }
}
