import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestsTypePage extends ConsumerWidget {
  final int enterpriseCode;
  final Modules module;
  final void Function(WidgetRef ref, BSFRequestTypeEntity request) onTap;

  const RequestsTypePage({
    super.key,
    required this.enterpriseCode,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = requestTypeStateControllerProvider(module, enterpriseCode);

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(
        title: 'Modelos de pedido'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(provider),
            tryAgain: () => ref.invalidate(provider),
            data: (requests) {
              if (requests?.isEmpty ?? true) {
                return Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nenhum modelo de pedido foi encontrado\n\nLembre-se que somente modelos que estão com o parâmetro "Permitir a utilização em pedidos feitos por aplicativos" aparecerão aqui'
                              .hardcoded,
                          textAlign: TextAlign.center,
                        ),
                        gapH16,
                        PrimaryButton(
                          text: 'Carregar novamente'.hardcoded,
                          onPressed: () => ref.invalidate(provider),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final List<BSFRequestTypeEntity> sortedRequests = List.from(
                requests!,
              );
              if (module == Modules.saleRequest) {
                final int? defaultRequestTypeCode = ref.watch(
                  selectedEnterpriseStateControllerProvider.select(
                    (s) => s?.SaleRequestTypeCode,
                  ),
                );

                sortedRequests.sort((a, b) {
                  final isADefault = a.code == defaultRequestTypeCode;
                  final isBDefault = b.code == defaultRequestTypeCode;
                  if (isADefault && !isBDefault) return -1;
                  if (!isADefault && isBDefault) return 1;
                  return (a.name ?? '').compareTo(b.name ?? '');
                });
              } else {
                sortedRequests.sort(
                  (a, b) => (a.name ?? '').compareTo(b.name ?? ''),
                );
              }

              return ResponsiveListFlow(
                itemCount: sortedRequests.length,
                itemBuilder: (_, index) {
                  final request = sortedRequests[index];

                  return _RequestTypeItem(
                    key: ValueKey(request.code),
                    request: request,
                    onTap: () => onTap(ref, request),
                    enterpriseCode: enterpriseCode,
                    module: module,
                  );
                },
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
  final int enterpriseCode;
  final Modules module;

  const _RequestTypeItem({
    super.key,
    required this.request,
    required this.onTap,
    required this.enterpriseCode,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (module == Modules.saleRequest)
                Consumer(
                  builder: (_, ref, _) {
                    final bool isDefaultRequestType = ref.watch(
                      selectedEnterpriseStateControllerProvider.select(
                        (s) => s?.SaleRequestTypeCode == request.code,
                      ),
                    );

                    if (!isDefaultRequestType) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Sizes.p4),
                      child: Text(
                        'Modelo padrão'.hardcoded,
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          color: context.theme.colorScheme.secondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  },
                ),

              if (request.personalizedCode?.isNotEmpty == true)
                TitleAndSubTitle(
                  title: module == Modules.transferRequest
                      ? 'Cód personalizado'.hardcoded
                      : 'Código'.hardcoded,
                  subTitle: request.personalizedCode,
                ),
              TitleAndSubTitle(title: 'Nome'.hardcoded, subTitle: request.name),
              if (module == Modules.transferRequest &&
                  request.operationType != null)
                TitleAndSubTitle(
                  title: 'Tipo de operação'.hardcoded,
                  subTitle: request.operationType?.name,
                ),
              TitleAndSubTitle(
                title: module == Modules.transferRequest
                    ? 'Preço praticado'.hardcoded
                    : 'Tipo preço'.hardcoded,
                subTitle: request.unitValueType?.description,
              ),
              TitleAndSubTitle(
                title: null,
                subTitle: request.allowAlterCostOrSalePrice == true
                    ? (module == Modules.transferRequest
                          ? "Pode alterar preço de custo ou venda".hardcoded
                          : 'Permite alterar o preço'.hardcoded)
                    : (module == Modules.transferRequest
                          ? "Não pode alterar preço de custo ou venda".hardcoded
                          : 'Não permite alterar o preço'.hardcoded),
                subTitleStyle: context.theme.textTheme.titleSmall?.copyWith(
                  color: request.allowAlterCostOrSalePrice == true
                      ? context.theme.primaryColor
                      : context.theme.colorScheme.error,
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (module == Modules.saleRequest)
                TitleAndSubTitle(
                  title: null,
                  subTitle: request.allowUseDiscount == true
                      ? 'Permite desconto manual'.hardcoded
                      : 'Não permite desconto manual'.hardcoded,
                  subTitleStyle: context.theme.textTheme.titleSmall?.copyWith(
                    color: request.allowUseDiscount == true
                        ? context.theme.primaryColor
                        : context.theme.colorScheme.error,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
