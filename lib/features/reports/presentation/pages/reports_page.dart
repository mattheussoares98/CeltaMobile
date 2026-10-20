import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/reports/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onRefresh() async {
      ref.invalidate(reportsStateControllerProvider);
    }

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: reportsStateControllerProvider,
      appBar: BaseAppBar(title: context.l10n.coreModulesReports),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(reportsStateControllerProvider),
            tryAgain: onRefresh,
            data: (reports) {
              return ResponsiveListFlow(
                itemCount: reports.length,
                itemBuilder: (_, index) {
                  final report = reports[index];

                  return _ReportItem(
                    key: ValueKey(report.Code),
                    report: report,
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
