import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/researchs/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResearchsPage extends ConsumerWidget {
  final int enterpriseCode;
  const ResearchsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = researchsStateControllerProvider(enterpriseCode);

    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      onRefresh: () => ref.refresh(provider.future),
      appBar: DefaultAppBar(
        title: 'Pesquisas cadastradas'.hardcoded,
        showSelectedEnterprise: true,
        actions: [InsertResearchButton(enterpriseCode: enterpriseCode)],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            tryAgain: () => ref.invalidate(researchsStateControllerProvider),
            value: ref.watch(provider),
            data: (researchs) {
              researchs.sort((a, b) => a.Code.compareTo(b.Code));

              return ResponsiveListFlow(
                itemCount: researchs.length,
                itemBuilder: (context, index) {
                  final research = researchs[index];
                  return ResearchItem(
                    key: ValueKey(research.Code),
                    research: research,
                    enterpriseCode: enterpriseCode,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
