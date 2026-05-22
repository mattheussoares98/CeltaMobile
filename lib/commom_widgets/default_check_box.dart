import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';

class DefaultCheckBox extends StatelessWidget {
  final String name;
  final Widget? subtitle;
  final bool enabled;
  final void Function(bool?)? onChanged;
  const DefaultCheckBox({
    super.key,
    required this.name,
    this.subtitle,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = PlatformUtil.isCupertino;

    return RepaintBoundary(
      child: AnimatedContainer(
        margin: const EdgeInsets.only(top: Sizes.p4),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: enabled ? theme.primaryColor.withAlpha(20) : theme.cardColor,
          borderRadius: BorderRadius.circular(Sizes.p12),
          border: Border.all(
            color: enabled
                ? theme.primaryColor
                : theme.dividerColor.withAlpha(40),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withAlpha(enabled ? 30 : 15),
              blurRadius: enabled ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.p12),
          child: isIOS
              ? CupertinoListTile(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p12,
                    vertical: Sizes.p4,
                  ),
                  title: Text(name, style: theme.textTheme.bodyMedium),
                  subtitle: subtitle,
                  trailing: CupertinoSwitch(
                    value: enabled,
                    onChanged: onChanged,
                  ),
                )
              : CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p12,
                    ),
                  title: Text(name, style: theme.textTheme.bodyMedium),
                  subtitle: subtitle,
                  value: enabled,
                  onChanged: onChanged,
                  dense: true,
                ),
        ),
      ),
    );
  }
}
