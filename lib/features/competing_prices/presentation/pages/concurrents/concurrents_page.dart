import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(
          title: 'Concorrentes (pesquisa $researchCode)'.hardcoded,
          enterpriseCode: enterpriseCode,
        ),
        actions: [
          ReloadIconButton(
            provider: researchsStateControllerProvider(enterpriseCode),
          ),
          gapW24,
          const InsertConcurrentButton(),
        ],
      ),
      body: AsyncValueWidget(
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
      ),
    );
  }
}
