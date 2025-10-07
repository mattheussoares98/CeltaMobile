import 'package:flutter/material.dart';

import '../../../../../constants/constants.dart';

class DefaultDivider extends StatelessWidget {
  final String title;
  const DefaultDivider(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        gapH16,
        Divider(thickness: 0.5),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        gapH8,
      ],
    );
  }
}
