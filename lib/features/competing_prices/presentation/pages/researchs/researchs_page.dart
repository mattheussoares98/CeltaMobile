import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ResearchsPage extends ConsumerWidget {
  final int enterpriseCode;
  const ResearchsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = researchsStateControllerProvider(enterpriseCode);

    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(
          title: 'Pesquisas cadastradas'.hardcoded,
          enterpriseCode: enterpriseCode,
        ),
        actions: [
          ReloadIconButton(provider: provider),
          gapW24,
          InsertResearchButton(enterpriseCode: enterpriseCode),
        ],
      ),
      body: AsyncValueWidget(
        tryAgain: () => ref.invalidate(researchsStateControllerProvider),
        value: ref.watch(provider),
        data: (researchs) {
          researchs.sort((a, b) => a.Code.compareTo(b.Code));

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(provider);
            },
            child: ResponsiveListFlow(
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
