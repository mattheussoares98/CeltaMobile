import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import 'buttons.dart';

class VisualizeFilePathButton extends ConsumerWidget {
  final DefaultButton widget;
  const VisualizeFilePathButton(this.widget, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return PrimaryTextButton(
      isSmall: true,
      text: 'Visualizar caminho'.hardcoded,
      icon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.eye,
        materialIcon: Icons.remove_red_eye,
      ),
      onPressed: () {
        showAlertDialog(
          context: context,
          title: 'Caminho do arquivo'.hardcoded,
          content: ref.read(
            downloadStateControllerProvider(
              widget.report.Code,
              widget.downloadType,
            ).select((s) => s.value?.xlsxFilePath),
          ),
        );
      },
    );
  }
}
