import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShallowBuyRequestItems extends ConsumerWidget {
  final int enterpriseCode;
  const ShallowBuyRequestItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTapItem(int buyRequestCode) {
      context.goNamed(
        Routes.buyRequestDetails.name,
        pathParameters: {
          'enterpriseCode': enterpriseCode.toString(),
          'buyRequestCode': buyRequestCode.toString(),
        },
      );
    }

    return AsyncValueWidget(
      value: ref.watch(
        shallowBuyRequestStateControllerProvider(enterpriseCode),
      ),
      tryAgain: null,
      data: (buyRequests) {
        if (buyRequests?.isEmpty == true) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: BaseText.error(context.l10n.noPurchaseOrdersFound),
            ),
          );
        }

        return ResponsiveListFlow(
          itemCount: buyRequests?.length ?? 0,
          itemBuilder: (context, index) {
            final item = buyRequests![index];

            return SearchedBuyRequestItem(
              buyRequest: item,
              onTapItem: () => onTapItem(item.code),
            );
          },
        );
      },
    );
  }
}
