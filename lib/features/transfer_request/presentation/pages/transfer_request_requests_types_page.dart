import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../routing/routing.dart';

class TransferRequestRequestsTypesPage extends ConsumerWidget {
  final int enterpriseCode;
  const TransferRequestRequestsTypesPage({
    super.key,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTap(BSFRequestTypeEntity request) {
      context.goNamed(
        Routes.transferRequestOriginEnterprises.name,
        pathParameters: {
          'requestTypeCode': request.code.toString(),
          'enterpriseCode': enterpriseCode.toString(),
        },
      );
    }

    final provider = requestTypeStateControllerProvider(
      Modules.transferRequest,
      enterpriseCode,
    );

    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(title: 'Modelos de pedido'.hardcoded),
        actions: [ReloadIconButton(provider: provider)],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(provider),
            tryAgain: () {
              ref.invalidate(provider);
            },
            data: (requests) {
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(provider);
                },
                child: ResponsiveListFlow(
                  itemCount: requests?.length ?? 0,
                  itemBuilder: (_, index) {
                    final request = requests![index];
                    return _RequestTypeItem(
                      key: ValueKey(request.code),
                      request: request,
                      onTap: () => onTap(request),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _RequestTypeItem extends StatelessWidget {
  final BSFRequestTypeEntity request;
  final VoidCallback onTap;
  const _RequestTypeItem({
    super.key,
    required this.request,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleAndSubTitle(title: 'Nome'.hardcoded, subTitle: request.name),
              if (request.personalizedCode?.isNotEmpty ?? false)
                TitleAndSubTitle(
                  title: 'Cód personalizado'.hardcoded,
                  subTitle: request.personalizedCode,
                ),
              TitleAndSubTitle(
                title: 'Tipo de operação'.hardcoded,
                subTitle: request.operationType?.name,
              ),
              TitleAndSubTitle(
                title: 'Preço praticado'.hardcoded,
                subTitle: request.unitValueType?.description,
              ),
              TitleAndSubTitle(
                title: null,
                subTitle: request.allowAlterCostOrSalePrice == true
                    ? "Pode alterar preço de custo ou venda"
                    : "Não pode alterar preço de custo ou venda",
                subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                  color: request.allowAlterCostOrSalePrice == true
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
