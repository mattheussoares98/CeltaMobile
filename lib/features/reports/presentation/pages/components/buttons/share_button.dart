import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/data/datasource/share_download/share_download.dart';
import '../../../../../../core/presentation/controllers/share_download/share_download.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';

class ShareButton extends ConsumerWidget {
  final Uint8List fileBytes;
  final ReportScheduleEntity report;
  const ShareButton({super.key, required this.fileBytes, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return InkWell(
      //TODO change to primaryTextButton
      onTap: () {
        ref
            .read(shareDownloadControllerProvider.notifier)
            .share(
              FileProperties(
                name: report.ReportModelName,
                bytes: fileBytes,
                extension: '.xlsx',
              ),
            );
      },
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            gapW4,
            Text(
              'Compartilhar'.hardcoded,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.primaryColor,
                fontStyle: FontStyle.italic,
              ),
            ),
            gapW8,
            Icon(
              isIOS ? CupertinoIcons.share : Icons.share,
              color: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
