import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
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
        DefaultTitle(title: title),
        gapH8,
      ],
    );
  }
}
