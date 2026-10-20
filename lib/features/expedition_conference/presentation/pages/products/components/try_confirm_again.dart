import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TryConfirmAgain extends ConsumerWidget {
  final int expeditionControlCode;
  final int stepCode;
  const TryConfirmAgain({
    super.key,
    required this.expeditionControlCode,
    required this.stepCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(
      confirmConferenceControllerProvider.select((value) => value.error),
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BaseText.error(
            context.l10n.conferenceConfirmationFailed(
              parseErrorMessage(error, translations: context.l10n),
            ),
            textAlign: TextAlign.center,
          ),
          PrimaryTextButton(
            text: context.l10n.tryAgain,
            onPressed: () {
              ref
                  .read(confirmConferenceControllerProvider.notifier)
                  .confirm(
                    expeditionControlCode: expeditionControlCode,
                    stepCode: stepCode,
                  );
            },
          ),
        ],
      ),
    );
  }
}
