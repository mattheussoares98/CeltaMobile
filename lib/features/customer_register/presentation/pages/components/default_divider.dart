import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';

class DefaultDivider extends StatelessWidget {
  final String title;
  const DefaultDivider(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        gapH16,
        const Divider(thickness: 0.5),
        DefaultTitle(title: title),
        gapH8,
      ],
    );
  }
}
