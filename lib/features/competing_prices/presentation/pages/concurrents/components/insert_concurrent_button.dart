import 'package:celta_intelligence/features/competing_prices/presentation/pages/insert_update_concurrent/insert_update_concurrent_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';

class InsertConcurrentButton extends StatelessWidget {
  const InsertConcurrentButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return IconButton(
      onPressed: () {
        showModalPage(
          const InsertUpdateConcurrentPage(concurrentUpdating: null),
          context,
        );
      },
      icon: Icon(isIOS ? CupertinoIcons.add : Icons.add),
    );
  }
}
