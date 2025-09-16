import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../routing/routing.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';

class Modules extends ConsumerWidget {
  const Modules({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    return ResponsiveFlowLayout(
      maxItemWidth: 200,
      items: [
        PrimaryButton(
          text: 'Alteração de preços'.hardcoded,
          onPressed: selectedEnterprise == null
              ? null
              : () {
                  context.goNamed(
                    AppRoute.adjustSalePriceProducts.name,
                    pathParameters: {
                      'enterpriseCode': selectedEnterprise.Code.toString(),
                    },
                    extra: {'enterprise': selectedEnterprise},
                  );
                },
        ),
      ],
    );
  }
}
