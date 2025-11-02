import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../controllers/controllers.dart';

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
    final confirmAsync = ref.watch(confirmConferenceControllerProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Houve um erro ao tentar confirmar a conferência: ${confirmAsync.error}'
                .hardcoded,
            textAlign: TextAlign.center,
          ),
          PrimaryTextButton(
            text: 'Tentar novamente'.hardcoded,
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
