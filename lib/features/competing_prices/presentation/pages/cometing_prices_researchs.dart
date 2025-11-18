import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../localization/string_hardcoded.dart';
import '../controllers/controllers.dart';

class CompetingPricesResearchs extends ConsumerWidget {
  final int enterpriseCode;
  const CompetingPricesResearchs({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text('Pesquisas cadastradas'.hardcoded)),
      ),
      body: AsyncValueWidget(
        tryAgain: () => ref.invalidate(researchsStateControllerProvider),
        value: ref.watch(researchsStateControllerProvider),
        data: (researchs) {
          return ListView.builder(
            itemCount: researchs.length,
            itemBuilder: (context, index) {
              final research = researchs[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      ),
                      TitleAndSubTitle(
                        title: 'Data de criação',
                        subTitle: DateFormat(
                          'dd/MM/yyyy',
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
          );
        },
      ),
    );
  }
}
