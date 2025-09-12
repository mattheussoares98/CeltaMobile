import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../routing/routing.dart';

class Modules extends StatelessWidget {
  const Modules({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveFlowLayout(
      maxItemWidth: 200,
      items: [
        PrimaryButton(
          text: 'Alteração de preços'.hardcoded,
          onPressed: () {
            context.pushNamed(
              AppRoute.enterprises.name,
              extra: AppRoute.adjustSalePriceProducts.name,
            );
          },
        ),
        PrimaryButton(
          text: 'Alteração de preços'.hardcoded,
          onPressed: () {
            context.pushNamed(AppRoute.enterprises.name);
          },
        ),
        PrimaryButton(
          text: 'Alteração de preços'.hardcoded,
          onPressed: () {
            context.pushNamed(AppRoute.enterprises.name);
          },
        ),
        PrimaryButton(
          text: 'Alteração de preços'.hardcoded,
          onPressed: () {
            context.pushNamed(AppRoute.enterprises.name);
          },
        ),
        PrimaryButton(
          text: 'Alteração de preços'.hardcoded,
          onPressed: () {
            context.pushNamed(AppRoute.enterprises.name);
          },
        ),
        PrimaryButton(
          text: 'Alteração de preços'.hardcoded,
          onPressed: () {
            context.pushNamed(AppRoute.enterprises.name);
          },
        ),
      ],
    );
  }
}
