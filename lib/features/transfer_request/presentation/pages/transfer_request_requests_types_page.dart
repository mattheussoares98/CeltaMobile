import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../routing/routing.dart';

class TransferRequestRequestsTypesPage extends ConsumerWidget {
  const TransferRequestRequestsTypesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(
      requestTypeStateControllerProvider(Modules.transferRequest),
    );
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Modelos de pedido'.hardcoded)),
      body: AsyncValueWidget(
        value: requestsAsync,
        tryAgain: () {
          ref.invalidate(
            requestTypeStateControllerProvider(Modules.transferRequest),
          );
        },
        data: (requests) {
          return ListView.builder(
            itemCount: requests?.length,
            itemBuilder: (_, index) {
              final request = requests![index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    context.goNamed(
                      Routes.transferRequestOriginEnterprises.name,
                      pathParameters: {
                        'requestTypeCode': request.Code.toString(),
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleAndSubTitle(
                          title: 'Nome'.hardcoded,
                          subTitle: request.Name,
                        ),
                        TitleAndSubTitle(
                          title: 'Cód personalizado'.hardcoded,
                          subTitle: request.PersonalizedCode,
                        ),
                        TitleAndSubTitle(
                          title: 'Tipo de operação'.hardcoded,
                          subTitle: request.OperationTypeString,
                        ),
                        if (request.UseWholePrice == 1)
                          TitleAndSubTitle(
                            title: 'Preço atacado'.hardcoded,
                            subTitle: request.UseWholePriceString,
                          ),
                        TitleAndSubTitle(
                          title: 'Preço praticado'.hardcoded,
                          subTitle: request.UnitValueTypeString,
                        ),
                        TitleAndSubTitle(
                          title: null,
                          subTitle: request.AllowAlterCostOrSalePrice == true
                              ? "Pode alterar preço de custo ou venda"
                              : "Não pode alterar preço de custo ou venda",
                          subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                            color: request.AllowAlterCostOrSalePrice == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
