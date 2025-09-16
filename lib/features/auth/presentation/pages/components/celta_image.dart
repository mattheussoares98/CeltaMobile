import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../routing/app_router.dart';

class CeltaImage extends StatelessWidget {
  const CeltaImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        context.pushNamed(AppRoute.enterpriseManager.name);
      },
      child: ResponsiveCenter(
        maxContentWidth: 300,
        child: Image.asset("lib/core/assets/images/logoCeltaTransparente.png"),
      ),
    );
  }
}
