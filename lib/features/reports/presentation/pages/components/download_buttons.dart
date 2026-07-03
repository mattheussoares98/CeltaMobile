// import 'package:open_file_plus/open_file_plus.dart';

import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/presentation/pages/components/buttons/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadButtons extends ConsumerWidget {
  final ReportScheduleEntity report;
  const DownloadButtons({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (report.LastExecutionContainsData != true) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: .center,
      children: [
        DefaultButton(DownloadType.pdf, report),
        gapH8,
        DefaultButton(DownloadType.xlsx, report),
      ],
    );
  }
}
