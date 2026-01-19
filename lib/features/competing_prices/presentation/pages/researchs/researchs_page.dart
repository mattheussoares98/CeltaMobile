import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ResearchsPage extends ConsumerWidget {
  final int enterpriseCode;
  const ResearchsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text('Pesquisas cadastradas'.hardcoded)),
        actions: const [InsertResearchButton()],
      ),
      body: AsyncValueWidget(
        tryAgain: () => ref.invalidate(researchsStateControllerProvider),
        value: ref.watch(researchsStateControllerProvider),
        data: (researchs) {
          researchs.sort((a, b) => a.Code.compareTo(b.Code));

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
                return ResearchItem(
                  key: ValueKey(research.Code),
                  research: research,
                  enterpriseCode: enterpriseCode,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
