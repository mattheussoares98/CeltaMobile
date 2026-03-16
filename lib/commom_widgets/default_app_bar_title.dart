import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/enterprises/presentation/controllers/controllers.dart';

class DefaultAppBarTitle extends StatelessWidget {
  final String? title;
  const DefaultAppBarTitle({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final centerTitle = theme.platform != TargetPlatform.android;

    return Column(
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (title != null) FittedBox(child: Text(title!)),
        const CorrespondentEnterpriseByEnterpriseCode(),
      ],
    );
  }
}

class CorrespondentEnterpriseByEnterpriseCode extends ConsumerWidget {
  final int? enterpriseCode;
  const CorrespondentEnterpriseByEnterpriseCode({
    super.key,
    this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterpriseCode =
        enterpriseCode ??
        ref.watch(
          selectedEnterpriseStateControllerProvider.select((s) => s?.Code),
        );

    final personalizedCode = ref.watch(
      enterprisesStateControllerProvider().select(
        (s) => s.value
            ?.firstWhereOrNull((x) => x.Code == selectedEnterpriseCode)
            ?.PersonalizedCode,
      ),
    );
    final enterpriseName = ref.watch(
      enterprisesStateControllerProvider().select(
        (s) => s.value
            ?.firstWhereOrNull((x) => x.Code == selectedEnterpriseCode)
            ?.name,
      ),
    );

    if (enterpriseName == null || personalizedCode == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final centerTitle = theme.platform != TargetPlatform.android;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '$personalizedCode - $enterpriseName',
            style: theme.textTheme.bodySmall,
            textAlign: centerTitle ? TextAlign.center : null,
          ),
        ),
      ],
    );
  }
}
