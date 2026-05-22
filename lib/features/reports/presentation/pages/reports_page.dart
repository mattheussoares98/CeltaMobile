import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/reports/presentation/pages/components/components.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'.hardcoded),
        actions: [ReloadIconButton(provider: reportsStateControllerProvider)],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(reportsStateControllerProvider),
            tryAgain: () => ref.invalidate(reportsStateControllerProvider),
            data: (reports) {
              return RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(reportsStateControllerProvider),
                child: ResponsiveListFlow(
                  itemCount: reports.length,
                  itemBuilder: (_, index) {
                    final report = reports[index];

                    return _ReportItem(
                      key: ValueKey(report.Code),
                      report: report,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ReportItem extends StatelessWidget {
  final ReportScheduleEntity report;
  const _ReportItem({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Informations(report: report),
            gapH8,
            ExecuteButton(report: report),
            gapH8,
            DownloadButtons(report: report),
          ],
        ),
      ),
    );
  }
}
