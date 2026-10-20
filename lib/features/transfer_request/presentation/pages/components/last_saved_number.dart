import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LastSavedNumber extends ConsumerWidget {
  const LastSavedNumber({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(lastSavedNumberStateControllerProvider),
      tryAgain: null,
      data: (number) {
        if (number == null) {
          return const SizedBox.shrink();
        }

        return FittedBox(
          child: TitleAndSubTitle(
            copyableSubtitle: true,
            title: context.l10n.lastSavedOrder,
            subTitle: RegExp(r'\((.*?)\)').firstMatch(number)?.group(1),
            subTitleStyle: context.theme.textTheme.titleMedium?.copyWith(
              color: context.theme.primaryColor,
            ),
          ),
        );
      },
    );
  }
}
