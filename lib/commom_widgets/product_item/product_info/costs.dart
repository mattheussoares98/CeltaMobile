import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Costs extends ConsumerWidget {
  const Costs({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScrollableWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: .center,
            children: [
              Flexible(
                child: BaseText.headline(
                  context.l10n.costs,
                  textAlign: TextAlign.center,
                ),
              ),
              gapW12,
              IconButton(
                onPressed: () {
                  ref
                      .read(tryAccessModuleControllerProvider.notifier)
                      .tryAccess(
                        context: context,
                        module: Modules.adjustCost,
                        route: Routes.adjustCost,
                        enterpriseCode: widget.product.EnterpriseCode,
                        extra: widget.product,
                        pathParameters: {
                          'enterpriseCode': widget.product.EnterpriseCode
                              .toString(),
                        },
                      );
                },
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.pencil,
                  materialIcon: Icons.edit,
                ),
              ),
            ],
          ),
          gapH8,
          TitleAndSubTitle(
            title: context.l10n.net,
            subTitle: widget.product.LiquidCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.averageNet,
            subTitle: widget.product.LiquidCostMidle,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.tax,
            subTitle: widget.product.FiscalCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.netTax,
            subTitle: widget.product.FiscalLiquidCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.operating,
            subTitle: widget.product.OperationalCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.actual,
            subTitle: widget.product.RealCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.actualNet,
            subTitle: widget.product.RealLiquidCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.replacement,
            subTitle: widget.product.ReplacementCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.averageReplacement,
            subTitle: widget.product.ReplacementCostMidle,
            subTitleIsPrice: true,
          ),
        ],
      ),
    );
  }
}
