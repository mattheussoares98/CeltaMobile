import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/reported_problems/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportedPrintLabelProblemsPage extends ConsumerWidget {
  const ReportedPrintLabelProblemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = reportedPrintLabelProblemsControllerProvider;

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(title: context.l10n.reportedIssues),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (reports) {
          if (reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BaseText(context.l10n.noReportedIssues),
                  gapH16,
                  PrimaryButton(
                    text: context.l10n.reload,
                    onPressed: () => ref.invalidate(provider),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (_, index) => ReportedPrintLabelProblemItem(
              key: ValueKey(reports[index].id),
              report: reports[index],
            ),
          );
        },
      ),
    );
  }
}
