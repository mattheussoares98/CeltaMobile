import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/presentation/controllers/app_usage/app_usage.dart';
import '../../../../../../../localization/string_hardcoded.dart';

class ReportsItems extends ConsumerWidget {
  const ReportsItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(appUsageStateControllerProvider),
      tryAgain: () {
        //TODO reload the reports
      },
      data: (usageReports) {
        if (usageReports?.isEmpty ?? true) {
          return SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
                  Text('Nenhum uso encontrado'.hardcoded),
                  ElevatedButton(
                    onPressed: () {
                      //TODO reload
                    },
                    child: Text('Carregar novamente'.hardcoded),
                  ),
                ],
              ),
            ),
          );
        }

        final usageByEnterprise = groupBy(
          usageReports!,
          (e) => e.enterpriseName ?? 'No group',
        );

        final groupEntries = usageByEnterprise.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        return ResponsiveListFlow(
          isSliver: true,
          itemCount: groupEntries.length,
          itemBuilder: (_, enterpriseIndex) {
            final enterpriseName = groupEntries[enterpriseIndex].key;
            final reports = groupEntries[enterpriseIndex].value;

            return Card(
              child: Column(
                children: [
                  Text(enterpriseName),
                  ...reports.map((e) {
                    return Text('${e.usageType.name}-${e.requestCount}');
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
