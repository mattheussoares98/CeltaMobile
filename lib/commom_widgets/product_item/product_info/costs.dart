import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';

class Costs extends ConsumerWidget {
  const Costs({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ResponsiveScrollableWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(child: DefaultTitle(title: 'Custos'.hardcoded)),
              IconButton(
                onPressed: () {
                  ref
                      .read(tryAccessModuleControllerProvider.notifier)
                      .tryAccess(
                        context: context,
                        module: Modules.adjustCost,
                        route: Routes.adjustCost,
                        enterpriseCode: widget.product.EnterpriseCode,
                        replace: false,
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
            title: 'Líquido '.hardcoded,
            subTitle: widget.product.LiquidCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: 'Líquido médio '.hardcoded,
            subTitle: widget.product.LiquidCostMidle,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: 'Fiscal '.hardcoded,
            subTitle: widget.product.FiscalCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: 'Fiscal líquido '.hardcoded,
            subTitle: widget.product.FiscalLiquidCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: 'Operacional '.hardcoded,
            subTitle: widget.product.OperationalCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: 'Real '.hardcoded,
            subTitle: widget.product.RealCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: 'Real líquido '.hardcoded,
            subTitle: widget.product.RealLiquidCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: 'Reposição '.hardcoded,
            subTitle: widget.product.ReplacementCost,
            subTitleIsPrice: true,
          ),
          TitleAndSubTitle(
            title: 'Reposição médio '.hardcoded,
            subTitle: widget.product.ReplacementCostMidle,
            subTitleIsPrice: true,
          ),
        ],
      ),
    );
  }
}
