import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/pages.dart';

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
