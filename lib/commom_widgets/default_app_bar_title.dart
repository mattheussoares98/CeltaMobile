import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:celta_inventario/utils/utils.dart';

class DefaultAppBarTitle extends StatelessWidget {
  final String? title;
  const DefaultAppBarTitle({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final centerTitle = context.theme.platform != TargetPlatform.android;

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

    final enterpriseData = ref.watch(
      enterprisesStateControllerProvider().select((s) {
        final enterprise = s.value?.firstWhereOrNull(
          (x) => x.Code == selectedEnterpriseCode,
        );
        return (
          personalizedCode: enterprise?.PersonalizedCode,
          enterpriseName: enterprise?.name,
        );
      }),
    );
    final personalizedCode = enterpriseData.personalizedCode;
    final enterpriseName = enterpriseData.enterpriseName;

    if (enterpriseName == null || personalizedCode == null) {
      return const SizedBox.shrink();
    }

    final centerTitle = context.theme.platform != TargetPlatform.android;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '$personalizedCode - $enterpriseName',
              style: context.theme.textTheme.bodySmall,
              textAlign: centerTitle ? TextAlign.center : null,
            ),
          ),
        ),
      ],
    );
  }
}
