import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controller.dart';

class SaveIconButton extends ConsumerWidget {
  final int enterpriseCode;
  final int code;
  final TextEditingController observationController;
  final FocusNode observationsFocusNode;

  const SaveIconButton({
    super.key,
    required this.enterpriseCode,
    required this.code,
    required this.observationController,
    required this.observationsFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final loadedComplete = ref.watch(
      completeBuyQuotationsStateControllerProvider(
        enterpriseCode,
        code.toString(),
      ).select((s) => s.value != null),
    );
    return RepaintBoundary(
      child: IconButton(
        onPressed: loadedComplete
            ? () async {
                if (observationsFocusNode.hasFocus) {
                  observationsFocusNode.unfocus();
                }
                bool updated = false;
                bool? pressedOk = await showAlertDialog(
                  context: context,
                  title: 'Salvar'.hardcoded,
                  content: 'Deseja salvar as alterações?'.hardcoded,
                  cancelActionText: 'Cancelar'.hardcoded,
                  defaultActionText: 'Salvar'.hardcoded,
                );

                if (pressedOk == true) {
                  FocusScope.of(context).unfocus();
                  updated = await ref
                      .read(
                        saveBuyQuotationControllerProvider(
                          enterpriseCode,
                          code.toString(),
                        ).notifier,
                      )
                      .save(observationController.text);
                }

                await Future.delayed(Duration.zero);
                if (updated) {
                  context.pop();
                }
              }
            : null,
        icon: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.check_mark,
          materialIcon: Icons.save,
        ),
      ),
    );
  }
}
