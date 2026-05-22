import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/pages.dart';

class ResearchItem extends ConsumerWidget {
  final ResearchEntity research;
  final int enterpriseCode;
  const ResearchItem({
    super.key,
    required this.research,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaSize = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: () {
          context.goNamed(
            Routes.competingPricesConcurrents.name,
            pathParameters: {
              'researchCode': research.Code.toString(),
              'enterpriseCode': enterpriseCode.toString(),
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleAndSubTitle(
                title: 'Código',
                subTitle: research.Code.toString(),
              ),
              TitleAndSubTitle(title: 'Nome', subTitle: research.Name),
              TitleAndSubTitle(
                title: null,
                subTitle: research.RestrictProducts
                    ? 'Produtos restringidos'.hardcoded
                    : 'Produtos NÃO restringidos'.hardcoded,
                subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                  color: research.RestrictProducts
                      ? theme.primaryColor
                      : Colors.red,
                ),
              ),
              TitleAndSubTitle(
                title: 'Data de criação',
                subTitle: DateFormat(
                  'dd/MM/yyyy HH:mm',
                ).format(research.CreationDate),
              ),
              if (research.Observation != null &&
                  research.Observation!.isNotEmpty)
                TitleAndSubTitle(
                  title: 'Observação',
                  subTitle: research.Observation,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryTextButton(
                    text: 'Alterar pesquisa'.hardcoded,
                    onPressed: () {
                      showModalPage(
                        InsertUpdateResearchPage(
                          research: research,
                          enterpriseCode: enterpriseCode,
                        ),
                        context,
                      );
                    },
                    icon: mediaSize.width > 300
                        ? const PlatformIcon(
                            cupertinoIcon: CupertinoIcons.pencil,
                            materialIcon: Icons.edit_outlined,
                          )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
