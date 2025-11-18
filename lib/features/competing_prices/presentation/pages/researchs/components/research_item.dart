import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';
import '../../pages.dart';

class ResearchItem extends StatelessWidget {
  final ResearchEntity research;
  const ResearchItem({super.key, required this.research});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TitleAndSubTitle(
                    title: 'Código',
                    subTitle: research.Code.toString(),
                  ),
                ),
                Flexible(
                  flex: 7,
                  child: PrimaryTextButton(
                    text: 'Alterar pesquisa'.hardcoded,
                    onPressed: () {
                      showModalPage(
                        InsertUpdateResearchPage(research: research),
                        context,
                      );
                    },
                    icon: mediaQuery.size.width > 300
                        ? Icon(
                            isIOS ? CupertinoIcons.pencil : Icons.edit_outlined,
                          )
                        : null,
                  ),
                ),
              ],
            ),
            TitleAndSubTitle(title: 'Nome', subTitle: research.Name),
            TitleAndSubTitle(
              title: null,
              subTitle: research.RestrictProducts
                  ? 'Produtos restringidos'.hardcoded
                  : 'Produtos NÃO restringidos'.hardcoded,
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
          ],
        ),
      ),
    );
  }
}
