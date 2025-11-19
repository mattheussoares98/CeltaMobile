import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ConcurrentsPage extends ConsumerWidget {
  final int researchCode;
  const ConcurrentsPage({super.key, required this.researchCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Concorrentes'.hardcoded),
          ), //TODO add action button to add a new concurrent
          body: AsyncValueWidget(
            value: ref.watch(researchsStateControllerProvider),
            tryAgain: () => ref.invalidate(researchsStateControllerProvider),
            data: (researchs) {
              final selectedResearch = researchs.firstWhere(
                (research) => research.Code == researchCode,
              );

              return AsyncValueWidget(
                value: ref.watch(concurrentsStateControllerProvider),
                tryAgain: () =>
                    ref.invalidate(concurrentsStateControllerProvider),
                data: (concurrents) {
                  return ConcurrentsItems(
                    concurrents: concurrents,
                    selectedResearch: selectedResearch,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
