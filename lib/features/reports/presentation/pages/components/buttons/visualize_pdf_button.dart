import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';

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
      text: 'Visualizar'.hardcoded,
      isSmall: true,
      onPressed: () {
        context.pushNamed(
          Routes.pdfViewer.name,
          extra: <String, dynamic>{'bytes': bytes, 'fileName': modelName},
        );
      },
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.eye,
        materialIcon: Icons.remove_red_eye,
      ),
    );
  }
}
