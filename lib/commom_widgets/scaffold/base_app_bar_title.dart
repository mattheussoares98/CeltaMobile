import 'package:celta_inventario/commom_widgets/text/text.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseAppBarTitle extends StatelessWidget {
  final String? title;
  final int? selectedEnterpriseCode;
  const BaseAppBarTitle({super.key, this.title, this.selectedEnterpriseCode});

  @override
  Widget build(BuildContext context) {
    final centerTitle = context.theme.platform != TargetPlatform.android;

    return Column(
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (title != null) FittedBox(child: BaseText.title(title!)),
        if (selectedEnterpriseCode != null)
          CorrespondentEnterpriseByEnterpriseCode(
            enterpriseCode: selectedEnterpriseCode!,
          ),
      ],
    );
  }
}

class CorrespondentEnterpriseByEnterpriseCode extends ConsumerWidget {
  final int enterpriseCode;
  const CorrespondentEnterpriseByEnterpriseCode({
    super.key,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterpriseCode = enterpriseCode;

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

    return Align(
      alignment: Alignment.centerLeft,
      child: BaseText.bodySmall(
        '$personalizedCode - $enterpriseName',
        textAlign: centerTitle ? TextAlign.center : null,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
