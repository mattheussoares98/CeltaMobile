import 'package:flutter/material.dart';

class UnselectedMessage extends StatelessWidget {
  final String title;
  const UnselectedMessage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: Colors.red,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
