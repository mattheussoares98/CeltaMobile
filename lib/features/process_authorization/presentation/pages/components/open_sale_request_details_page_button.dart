import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OpenSaleRequestDetailsPageButton extends ConsumerWidget {
  final String title;
  final int processCode;
  const OpenSaleRequestDetailsPageButton({
    super.key,
    required this.title,
    required this.processCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(judgmentDetailsStateControllerProvider(processCode)),
      tryAgain: () =>
          ref.invalidate(judgmentDetailsStateControllerProvider(processCode)),
      data: (judgment) {
        final saleRequest = judgment.defendants
            ?.cast<BSFSaleRequestDefendantEntity>()
            .firstOrNull
            ?.saleRequest;

        final applyedTitle = saleRequest == null
            ? title
            : '$title (${saleRequest.personalizedCode})';

        return LayoutBuilder(
          builder: (context, constraints) {
            return InkWell(
              onTap: saleRequest == null
                  ? null
                  : () {
                      context.pushNamed(
                        Routes.saleRequestDetails.name,
                        pathParameters: {
                          'saleRequestId': saleRequest.code.toString(),
                          'enterpriseCode': saleRequest.enterprise!.code
                              .toString(),
                          'customerCode': saleRequest.customer!.code.toString(),
                        },
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Flexible(
                      child: BaseText(
                        applyedTitle,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    if (constraints.maxWidth > 200) ...[
                      gapW4,
                      PlatformIcon(
                        cupertinoIcon: CupertinoIcons.arrow_up_right,
                        materialIcon: Icons.arrow_outward,
                        color: context.colorScheme.primary,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
