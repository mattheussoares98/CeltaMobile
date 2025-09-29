import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../routing/routing.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';
import 'components.dart';

class Modules extends ConsumerWidget {
  const Modules({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    final buttons = <DefaultModuleButton>[
      DefaultModuleButton(
        selectedEnterprise: selectedEnterprise,
        route: AppRoute.adjustSalePriceProducts,
        pathParameters: selectedEnterprise == null
            ? null
            : {'enterpriseCode': selectedEnterprise.Code.toString()},
        extra: {'enterprise': selectedEnterprise},
      ),
      DefaultModuleButton(
        selectedEnterprise: selectedEnterprise,
        route: AppRoute.adjustStocks,
        pathParameters: selectedEnterprise == null
            ? null
            : {'enterpriseCode': selectedEnterprise.Code.toString()},
        extra: {'enterprise': selectedEnterprise},
      ),
      DefaultModuleButton(
        selectedEnterprise: selectedEnterprise,
        route: AppRoute.transferBetweenStocks,
        pathParameters: selectedEnterprise == null
            ? null
            : {'enterpriseCode': selectedEnterprise.Code.toString()},
        extra: {'enterprise': selectedEnterprise},
      ),
    ];

    buttons.sort((a, b) => a.route.module.compareTo(b.route.module));

    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: ResponsiveListFlow(
        maxItemWidth: 140,
        itemCount: buttons.length,
        itemBuilder: (_, index) {
          final button = buttons[index];
          return button;
        },
      ),
    );
  }
}
