import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final bool? enabled;
  const TitleWidget({super.key, required this.title, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: enabled == true ? null : theme.disabledColor,
      ),
    );
  }
}
