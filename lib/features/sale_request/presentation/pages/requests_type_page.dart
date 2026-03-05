import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../routing/routing.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';

class RequestsTypePage extends ConsumerWidget {
  final int enterpriseCode;
  const RequestsTypePage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = requestTypeStateControllerProvider(
      Modules.saleRequest,
      enterpriseCode,
    );
    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(title: 'Modelos de pedido'.hardcoded),
        actions: [ReloadIconButton(provider: provider)],
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () {
          ref.invalidate(provider);
        },
        data: (requests) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(provider),
            child: ResponsiveListFlow(
              itemCount: requests?.length ?? 0,
              itemBuilder: (_, index) {
                final request = requests![index];

                return _RequestTypeItem(
                  key: ValueKey(request.Code),
                  request: request,
                  onTap: () => context.goNamed(
                    Routes.saleRequest.name,
                    pathParameters: {
                      'enterpriseCode': enterpriseCode.toString(),
                      'requestCode': request.Code.toString(),
                    },
                  ),
                  enterpriseCode: enterpriseCode,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _RequestTypeItem extends StatelessWidget {
  final RequestTypeEntity request;
  final VoidCallback onTap;
  final int enterpriseCode;
  const _RequestTypeItem({
    super.key,
    required this.request,
    required this.onTap,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
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
                Consumer(
                  builder: (_, ref, _) {
                    final bool isDefaultRequestType = ref.watch(
                      selectedEnterpriseStateControllerProvider.select(
                        (s) => s?.SaleRequestTypeCode == request.Code,
                      ),
                    );

                    if (!isDefaultRequestType) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      'Modelo padrão'.hardcoded,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontStyle: FontStyle.italic,
                      ),
                    );
                  },
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
                TitleAndSubTitle(
                  title: null,
                  subTitle: request.AllowAlterCostOrSalePrice == true
                      ? 'Permite alterar o preço'.hardcoded
                      : 'Não permite alterar o preço'.hardcoded,
                  subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                    color: request.AllowAlterCostOrSalePrice == true
                        ? theme.primaryColor
                        : theme.colorScheme.error,
                  ),
                ),
                TitleAndSubTitle(
                  title: null,
                  subTitle: request.AllowDiscount == true
                      ? 'Permite desconto manual'.hardcoded
                      : 'Não permite desconto manual'.hardcoded,
                  subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                    color: request.AllowDiscount == true
                        ? theme.primaryColor
                        : theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
