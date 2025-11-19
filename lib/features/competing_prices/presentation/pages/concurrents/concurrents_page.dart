import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';

class ConcurrentsPage extends ConsumerWidget {
  final int researchCode;
  const ConcurrentsPage({super.key, required this.researchCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('Concorrentes'.hardcoded)),
          body: AsyncValueWidget(
            value: ref.watch(researchsStateControllerProvider),
            tryAgain: () => ref.invalidate(researchsStateControllerProvider),
            data: (researchs) {
              return AsyncValueWidget(
                value: ref.watch(concurrentsStateControllerProvider),
                tryAgain: () =>
                    ref.invalidate(concurrentsStateControllerProvider),
                data: (concurrents) {
                  return ListView.builder(
                    itemCount: concurrents.length,
                    itemBuilder: (context, index) {
                      final concurrent = concurrents[index];
                      return Text(concurrent.Name ?? '');
                    },
                  );
                },
              );
            },
          ),
        ),
        Consumer(
          builder: (_, ref, _) {
            final isLoading =
                ref.watch(
                  concurrentsStateControllerProvider.select((s) => s.isLoading),
                ) ||
                ref.watch(
                  researchsStateControllerProvider.select((s) => s.isLoading),
                );

            if (isLoading) {
              return const LoadingPage();
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
