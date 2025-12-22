import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
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

    return PrimaryTextButton(
      text: 'Compartilhar'.hardcoded,
      isSmall: true,
      onPressed: () {
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
      icon: Icon(isIOS ? CupertinoIcons.share : Icons.share),
    );
  }
}
