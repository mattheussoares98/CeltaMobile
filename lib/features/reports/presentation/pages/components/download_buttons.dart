import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:open_file_plus/open_file_plus.dart';

import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import 'buttons/buttons.dart';

class DownloadButtons extends ConsumerWidget {
  final ReportScheduleEntity report;
  const DownloadButtons({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (report.LastExecutionContainsData != true) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultButton(DownloadType.pdf, report),
        gapH8,
        DefaultButton(DownloadType.xlsx, report),
      ],
    );
  }
}
