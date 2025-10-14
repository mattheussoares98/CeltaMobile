import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class TryConfirmAgain extends ConsumerWidget {
  final AsyncValue<void> confirmAsync;
  final int expeditionControlCode;
  final int stepCode;
  final EnterpriseEntity? selectedEnterprise;
  const TryConfirmAgain({
    super.key,
    required this.confirmAsync,
    required this.expeditionControlCode,
    required this.stepCode,
    required this.selectedEnterprise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  .read(
                    confirmConferenceControllerProvider(
                      selectedEnterprise?.name ?? '',
                    ).notifier,
                  )
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
