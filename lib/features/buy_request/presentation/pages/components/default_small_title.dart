import 'package:flutter/material.dart';

class DefaultSmallTitle extends StatelessWidget {
  final String title;
  const DefaultSmallTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
    );
  }
}
