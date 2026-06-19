import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CeltaImage extends StatelessWidget {
  const CeltaImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        context.pop();
        context.pushNamed(Routes.enterpriseManager.name);
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p8),
        child: LogoWidget(),
      ),
    );
  }
}
