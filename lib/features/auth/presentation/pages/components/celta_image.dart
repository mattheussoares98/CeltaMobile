import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CeltaImage extends StatelessWidget {
  const CeltaImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        context.pushNamed(Routes.enterpriseManager.name);
      },
      child: const ResponsiveCenter(maxContentWidth: 300, child: LogoWidget()),
    );
  }
}
