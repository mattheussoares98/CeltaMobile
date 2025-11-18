import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../localization/string_hardcoded.dart';
import '../controllers/controllers.dart';
import 'pages.dart';

class ResearchsPage extends ConsumerWidget {
  final int enterpriseCode;
  const ResearchsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text('Pesquisas cadastradas'.hardcoded)),
        actions: [
          IconButton(
            onPressed: () {
              showModalPage(
                const InsertUpdateResearchPage(research: null),
                context,
              );
            },
            icon: Icon(isIOS ? CupertinoIcons.add : Icons.add),
          ),
        ],
      ),
      body: AsyncValueWidget(
        tryAgain: () => ref.invalidate(researchsStateControllerProvider),
        value: ref.watch(researchsStateControllerProvider),
        data: (researchs) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                researchsStateControllerProvider,
              ); //TODO test and add in all pages that is possible reload the list
            },
            child: ListView.builder(
              itemCount: researchs.length,
              itemBuilder: (context, index) {
                final research = researchs[index];
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
                                    InsertUpdateResearchPage(
                                      research: research,
                                    ),
                                    context,
                                  );
                                },
                                icon: mediaQuery.size.width > 300
                                    ? Icon(
                                        isIOS
                                            ? Icons.edit
                                            : Icons.edit_outlined,
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        TitleAndSubTitle(
                          title: 'Nome',
                          subTitle: research.Name,
                        ),
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
              },
            ),
          );
        },
      ),
    );
  }
}
