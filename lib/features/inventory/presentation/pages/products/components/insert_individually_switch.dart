import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/inventory/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsertIndividuallySwitch extends ConsumerWidget {
  final int codigoInternoInventario;
  const InsertIndividuallySwitch({
    super.key,
    required this.codigoInternoInventario,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widthScreen = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: Breakpoint.desktop,
      child: Padding(
        padding: const EdgeInsets.only(top: Sizes.p8),
        child: Row(
          children: [
            if (widthScreen > 200)
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 5),
                message:
                    'Quando essa opção está ativa, ao encontrar um único produto na busca, será somado automaticamente 1 quantidade'
                        .hardcoded,
                child: const Padding(
                  padding: EdgeInsets.only(right: Sizes.p4),
                  child: PlatformIcon(
                    cupertinoIcon: CupertinoIcons.info,
                    materialIcon: Icons.info_outline,
                  ),
                ),
              ),
            Flexible(
              child: Consumer(
                builder: (_, ref, _) {
                  return BaseSwitch(
                    title: 'Inserir individualmente'.hardcoded,
                    value: ref.watch(
                      uiStateControllerProvider(
                        codigoInternoInventario,
                      ).select((s) => s.insertIndividually),
                    ),
                    onChanged: (_) => ref
                        .read(
                          uiStateControllerProvider(
                            codigoInternoInventario,
                          ).notifier,
                        )
                        .updateInsertIndividually(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
