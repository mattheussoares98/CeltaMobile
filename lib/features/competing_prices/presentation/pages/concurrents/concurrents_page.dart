import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/concurrents/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConcurrentsPage extends ConsumerWidget {
  final int researchCode;
  final int enterpriseCode;
  const ConcurrentsPage({
    super.key,
    required this.researchCode,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(insertUpdateResearchControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    ref.observeLoading([insertUpdateResearchControllerProvider]);

    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      refreshProvider: researchsStateControllerProvider(enterpriseCode),
      appBar: BaseAppBar(
        title: 'Concorrentes (pesquisa $researchCode)'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
        actions: const [InsertConcurrentButton()],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(researchsStateControllerProvider(enterpriseCode)),
            tryAgain: () => ref.invalidate(researchsStateControllerProvider),
            data: (researchs) {
              final selectedResearch = researchs.firstWhere(
                (research) => research.Code == researchCode,
              );

              return ConcurrentsItems(
                selectedResearch: selectedResearch,
                enterpriseCode: enterpriseCode,
              );
            },
          );
        },
      ),
    );
  }
}
