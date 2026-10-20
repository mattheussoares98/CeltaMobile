import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/data/datasource/share_download/share_download.dart';
import 'package:celta_inventario/core/presentation/controllers/share_download/share_download.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppBarWithTitle extends ConsumerWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(35);

  final String fileName;
  final VoidCallback toggleSearchUI;
  final Uint8List bytes;
  const AppBarWithTitle({
    super.key,
    required this.fileName,
    required this.toggleSearchUI,
    required this.bytes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWindows = context.theme.platform == TargetPlatform.windows;

    ref.listen(shareDownloadControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    return AppBar(
      leading: IconButton(
        icon: const PlatformIcon(
          cupertinoIcon: Icons.arrow_back_ios,
          materialIcon: Icons.arrow_back,
        ),
        onPressed: context.pop,
      ),
      title: FittedBox(child: Text(fileName)),
      actions: [
        if (isWindows || kIsWeb)
          IconButton(
            onPressed: () async {
              await ref
                  .read(shareDownloadControllerProvider.notifier)
                  .download(
                    FileProperties(
                      name: fileName,
                      bytes: bytes,
                      extension: '.pdf',
                    ),
                    context.theme.platform,
                  );
            },
            icon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.cloud_download,
              materialIcon: Icons.download,
            ),
          )
        else
          IconButton(
            icon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.share,
              materialIcon: Icons.share,
            ),
            onPressed: () async {
              await ref
                  .read(shareDownloadControllerProvider.notifier)
                  .share(
                    FileProperties(
                      name: fileName,
                      bytes: bytes,
                      extension: '.pdf',
                    ),
                  );
            },
            tooltip: context.l10n.share,
          ),
        IconButton(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.search,
            materialIcon: Icons.search,
          ),
          onPressed: toggleSearchUI,
          tooltip: context.l10n.search,
        ),
      ],
    );
  }
}
