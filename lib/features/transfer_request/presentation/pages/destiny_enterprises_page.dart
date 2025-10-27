import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class DestinyEnterprisesPage extends ConsumerWidget {
  final int requestTypeCode;
  final int enterpriseOriginCode;
  const DestinyEnterprisesPage({
    super.key,
    required this.requestTypeCode,
    required this.enterpriseOriginCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinyAsync = ref.watch(
      destinyEnterprisesStateControllerProvider(
        enterpriseOriginCode: enterpriseOriginCode,
        requestTypeCode: requestTypeCode,
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text('Empresa de destino'.hardcoded)),
      body: AsyncValueWidget(
        value: destinyAsync,
        tryAgain: () {
          ref.invalidate(
            destinyEnterprisesStateControllerProvider(
              enterpriseOriginCode: enterpriseOriginCode,
              requestTypeCode: requestTypeCode,
            ),
          );
        },
        data: (enterprises) {
          return EnterpriseItems(
            enterprises: enterprises,
            onTap: () {
              //TODO navigate to another page
            },
            onRefresh: () {
              ref.invalidate(
                destinyEnterprisesStateControllerProvider(
                  enterpriseOriginCode: enterpriseOriginCode,
                  requestTypeCode: requestTypeCode,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
