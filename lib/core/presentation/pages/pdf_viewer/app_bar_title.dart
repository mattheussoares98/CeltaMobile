import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../commom_widgets/commom_widgets.dart';

class AppBarWithTitle extends StatelessWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Future<void> sharePdf() async {
      try {
        final pdfFile = XFile.fromData(
          bytes,
          name: fileName,
          mimeType: 'application/pdf',
        );

        await SharePlus.instance.share(
          ShareParams(
            files: [pdfFile],
            text: "Compartilhar PDF",
            downloadFallbackEnabled: true,
            title: fileName,
            previewThumbnail: pdfFile,
            mailToFallbackEnabled: true,
            fileNameOverrides: ['$fileName.pdf'],
          ),
        );
      } catch (e) {
        debugPrint("❌ An error occurred while sharing the PDF: $e");
        if (context.mounted) {
          showSnackBarMessage(
            context,
            'Não foi possível compartilhar o arquivo: $e',
          );
        }
      }
    }

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
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: sharePdf,
          tooltip: 'Compartilhar',
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: toggleSearchUI,
          tooltip: 'Pesquisar',
        ),
      ],
    );
  }
}
