import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Relatórios'.hardcoded)),
      body: AsyncValueWidget(
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

                return _ReportItem(key: ValueKey(report.Code), report: report);
              },
            ),
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
    return RepaintBoundary(
      child: Card(
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
      ),
    );
  }
}
