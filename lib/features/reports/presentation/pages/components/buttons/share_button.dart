import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/data/datasource/share_download/share_download.dart';
import 'package:celta_inventario/core/presentation/controllers/share_download/share_download.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShareButton extends ConsumerWidget {
  final Uint8List fileBytes;
  final ReportScheduleEntity report;
  const ShareButton({super.key, required this.fileBytes, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryTextButton(
      text: context.l10n.share,
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
      platformIcon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.share,
        materialIcon: Icons.share,
      ),
    );
  }
}
