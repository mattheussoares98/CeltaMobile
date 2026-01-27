import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../pages.dart';

class InsertResearchButton extends StatelessWidget {
  final int enterpriseCode;
  const InsertResearchButton({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return IconButton(
      onPressed: () {
        showModalPage(
          InsertUpdateResearchPage(
            research: null,
            enterpriseCode: enterpriseCode,
          ),
          context,
        );
      },
      icon: Icon(isIOS ? CupertinoIcons.add : Icons.add),
    );
  }
}
