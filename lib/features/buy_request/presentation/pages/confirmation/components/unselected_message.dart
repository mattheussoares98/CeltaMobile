import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../constants/constants.dart';

class UnselectedMessage extends StatelessWidget {
  final String title;
  const UnselectedMessage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return SliverToBoxAdapter(
      child: Row(
        children: [
          Flexible(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          gapW12,
          Icon(
            isIOS
                ? CupertinoIcons.exclamationmark_triangle
                : Icons.report_problem_rounded,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }
}
