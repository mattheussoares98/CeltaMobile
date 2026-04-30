import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../pages.dart';

class InsertResearchButton extends StatelessWidget {
  final int enterpriseCode;
  const InsertResearchButton({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context) {
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
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.add,
        materialIcon: Icons.add,
      ),
    );
  }
}
