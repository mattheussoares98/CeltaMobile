import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_movement/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShallowBuyMovementItems extends ConsumerWidget {
  final int enterpriseCode;
  const ShallowBuyMovementItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTapItem(int buyMovementCode) {
      context.goNamed(
        Routes.buyMovementDetails.name,
        pathParameters: {
          'enterpriseCode': enterpriseCode.toString(),
          'buyMovementCode': buyMovementCode.toString(),
        },
      );
    }

    return AsyncValueWidget(
      value: ref.watch(
        shallowBuyMovementStateControllerProvider(enterpriseCode),
      ),
      tryAgain: null,
      data: (buyMovements) {
        if (buyMovements?.isEmpty == true) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: BaseText.error('A compra não foi encontrado'.hardcoded),
            ),
          );
        }

        return ResponsiveListFlow(
          itemCount: buyMovements?.length ?? 0,
          itemBuilder: (context, index) {
            final item = buyMovements![index];

            return SearchedBuyMovementItem(
              buyMovement: item,
              onTapItem: () => onTapItem(item.code),
            );
          },
        );
      },
    );
  }
}
