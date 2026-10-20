import 'package:celta_inventario/utils/utils.dart';
import 'dart:typed_data';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VisualizePdfButton extends ConsumerWidget {
  final Uint8List bytes;
  final String modelName;
  const VisualizePdfButton({
    super.key,
    required this.bytes,
    required this.modelName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryTextButton(
      text: context.l10n.view,
      isSmall: true,
      onPressed: () {
        context.pushNamed(
          Routes.pdfViewer.name,
          extra: <String, dynamic>{'bytes': bytes, 'fileName': modelName},
        );
      },
      platformIcon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.eye,
        materialIcon: Icons.remove_red_eye,
      ),
    );
  }
}
