import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/enterprises/presentation/controllers/controllers.dart';

class DefaultAppBarTitle extends StatelessWidget {
  final int enterpriseCode;
  final String? title;
  const DefaultAppBarTitle({
    super.key,
    required this.enterpriseCode,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Column(
      crossAxisAlignment: isIOS
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (title != null) FittedBox(child: Text(title!)),
        CorrespondentEnterpriseByEnterpriseCode(enterpriseCode),
      ],
    );
  }
}

class CorrespondentEnterpriseByEnterpriseCode extends ConsumerWidget {
  final int enterpriseCode;
  const CorrespondentEnterpriseByEnterpriseCode(
    this.enterpriseCode, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correspondentEnterprise = ref.watch(
      enterprisesStateControllerProvider().select(
        (s) => s.value?.firstWhereOrNull((x) => x.Code == enterpriseCode),
      ),
    );

    if (correspondentEnterprise == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '${correspondentEnterprise.PersonalizedCode} - ${correspondentEnterprise.name}',
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
