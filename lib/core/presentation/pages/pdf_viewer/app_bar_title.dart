import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/utils.dart';
import '../../../data/datasource/share_download/share_download.dart';
import '../../controllers/share_download/share_download.dart';

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
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final isWindows = theme.platform == TargetPlatform.windows;

    ref.listen(shareDownloadControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    return AppBar(
      leading: IconButton(
        icon: Icon(
          theme.platform == TargetPlatform.iOS
              ? Icons.arrow_back_ios
              : Icons.arrow_back,
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
                    theme.platform,
                  );
            },
            icon: Icon(isIOS ? CupertinoIcons.cloud_download : Icons.download),
          )
        else
          IconButton(
            icon: Icon(isIOS ? CupertinoIcons.share : Icons.share),
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
            tooltip: 'Compartilhar',
          ),
        IconButton(
          icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
          onPressed: toggleSearchUI,
          tooltip: 'Pesquisar',
        ),
      ],
    );
  }
}
