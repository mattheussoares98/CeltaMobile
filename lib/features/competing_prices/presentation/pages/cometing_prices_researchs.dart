import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../localization/string_hardcoded.dart';
import '../controllers/controllers.dart';

class CompetingPricesResearchs extends ConsumerWidget {
  final int enterpriseCode;
  const CompetingPricesResearchs({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Preços concorrentes'.hardcoded)),
      body: AsyncValueWidget(
        tryAgain: () => ref.invalidate(researchsStateControllerProvider),
        value: ref.watch(researchsStateControllerProvider),
        data: (researchs) {
          return ListView.builder(
            itemCount: researchs.length,
            itemBuilder: (context, index) {
              final research = researchs[index];
              return ListTile(title: Text(research.EnterpriseName));
            },
          );
        },
      ),
    );
  }
}
