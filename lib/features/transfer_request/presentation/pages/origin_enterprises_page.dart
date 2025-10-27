import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../routing/routes.dart';
import '../../../enterprise_manager/domain/entities/entities.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import 'components/components.dart';

class OriginEnterprisesPage extends ConsumerWidget {
  final int requestTypeCode;
  const OriginEnterprisesPage({super.key, required this.requestTypeCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesAsync = ref.watch(
      enterprisesStateControllerProvider(module: Modules.transferRequest),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Empresa de origem'.hardcoded)),
      body: AsyncValueWidget(
        value: enterprisesAsync,
        tryAgain: () {
          ref.invalidate(
            enterprisesStateControllerProvider(module: Modules.transferRequest),
          );
        },
        data: (enterprises) {
          //TODO treat if the enterprise is enabled or not
          return EnterpriseItems(
            enterprises: enterprises,
            onTap: (enterprise) {
              context.goNamed(
                Routes.transferRequestDestinyEnterprises.name,
                pathParameters: {
                  'requestTypeCode': requestTypeCode.toString(),
                  'enterpriseOriginCode': enterprise.Code.toString(),
                },
              );
            },
            onRefresh: () {
              ref.invalidate(
                enterprisesStateControllerProvider(
                  module: Modules.transferRequest,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
