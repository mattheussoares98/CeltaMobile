import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../routing/routing.dart';

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
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return PrimaryTextButton(
      text: 'Visualizar'.hardcoded,
      isSmall: true,
      onPressed: () {
        context.pushNamed(
          Routes.pdfViewer.name,
          extra: <String, dynamic>{'bytes': bytes, 'fileName': modelName},
        );
      },
      icon: Icon(isIOS ? CupertinoIcons.eye : Icons.remove_red_eye),
    );
  }
}
