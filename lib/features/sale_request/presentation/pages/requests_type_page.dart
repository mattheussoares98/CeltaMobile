import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../routing/routing.dart';
import '../../../enterprise_manager/domain/entities/entities.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';

class RequestsTypePage extends ConsumerWidget {
  final int enterpriseCode;
  const RequestsTypePage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(
      requestTypeStateControllerProvider(Modules.saleRequest),
    );
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text('Modelos de pedido'.hardcoded)),
      ),
      body: AsyncValueWidget(
        value: requestsAsync,
        tryAgain: () {
          ref.invalidate(
            requestTypeStateControllerProvider(Modules.saleRequest),
          );
        },
        data: (requests) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                requestTypeStateControllerProvider(Modules.saleRequest),
              );
            },
            child: ListView.builder(
              itemCount: requests?.length,
              itemBuilder: (_, index) {
                final request = requests![index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  color: selectedEnterprise?.SaleRequestTypeCode == request.Code
                      ? theme.primaryColorLight
                      : null,
                  child: InkWell(
                    onTap: () {
                      context.goNamed(
                        Routes.saleRequest.name,
                        pathParameters: {
                          'enterpriseCode': enterpriseCode.toString(),
                          'requestCode': request.Code.toString(),
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedEnterprise?.SaleRequestTypeCode ==
                              request.Code)
                            Text(
                              'Modelo padrão'.hardcoded,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.primaryColorDark,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          TitleAndSubTitle(
                            title: 'Código'.hardcoded,
                            subTitle: request.PersonalizedCode,
                          ),
                          TitleAndSubTitle(
                            title: 'Nome'.hardcoded,
                            subTitle: request.Name,
                          ),
                          TitleAndSubTitle(
                            title: 'Tipo preço'.hardcoded,
                            subTitle: request.UnitValueTypeString,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
