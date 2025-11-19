import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ConcurrentsPage extends ConsumerWidget {
  final int researchCode;
  const ConcurrentsPage({super.key, required this.researchCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(insertUpdateResearchControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () {
        // context.pushNamed(Route.competingPrices.name);//TODO add the new page and navigate to it
      });
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: FittedBox(
              child: Text('Concorrentes (pesquisa $researchCode)'.hardcoded),
            ),
          ), //TODO add action button to add a new concurrent
          body: AsyncValueWidget(
            value: ref.watch(researchsStateControllerProvider),
            tryAgain: () => ref.invalidate(researchsStateControllerProvider),
            data: (researchs) {
              final selectedResearch = researchs.firstWhere(
                (research) => research.Code == researchCode,
              );

              return ConcurrentsItems(selectedResearch: selectedResearch);
            },
          ),
        ),
        LoadingPage(providers: [insertUpdateResearchControllerProvider]),
      ],
    );
  }
}
