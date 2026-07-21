import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/search/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShallowBuyRequestsPage extends ConsumerWidget {
  final int enterpriseCode;
  const ShallowBuyRequestsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      padding: const EdgeInsets.fromLTRB(Sizes.p8, Sizes.p8, Sizes.p8, 0),
      appBar: BaseAppBar(
        title: 'Consulta de pedidos de compras'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
      ),
      pinnedBody: Padding(
        padding: const EdgeInsets.only(bottom: Sizes.p12),
        child: SelectDateAndSearchButton(enterpriseCode: enterpriseCode),
      ),
      body: CustomScrollView(
        slivers: [
          Consumer(
            builder: (_, ref, _) {
              final provider = shallowBuyRequestStateControllerProvider(
                enterpriseCode,
              );
              return AsyncValueWidget(
                value: ref.watch(provider),
                tryAgain: null,
                isSliver: true,
                data: (buyRequests) {
                  if (buyRequests?.isEmpty == true) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: BaseText.error(
                          'Nenhum pedido de compra foi encontrado'.hardcoded,
                        ),
                      ),
                    );
                  }

                  return ResponsiveListFlow(
                    isSliver: true,
                    itemCount: buyRequests?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = buyRequests![index];

                      final principalEnterprise = item.enterprises
                          ?.firstWhereOrNull((e) => e.isPrincipal == true);
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.p8),
                          child: Column(
                            crossAxisAlignment: .stretch,
                            children: [
                              TitleAndSubTitle(
                                title: 'Empresa'.hardcoded,
                                subTitle:
                                    '${principalEnterprise?.enterprise?.personalizedCode ?? ''} - ${principalEnterprise?.enterprise?.name ?? ''}',
                              ),
                              if (item.personalizedCode != null)
                                BaseRichText(
                                  texts: [
                                    BaseText('Cód personalizado: '.hardcoded),
                                    BaseText.titleMedium(
                                      item.personalizedCode!
                                          .substring(0, 8)
                                          .hardcoded,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    BaseText.titleMedium(
                                      item.personalizedCode!
                                          .substring(8, 12)
                                          .hardcoded,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          context.theme.colorScheme.secondary,
                                    ),
                                  ],
                                ),
                              TitleAndSubTitle(
                                title: 'Criado em'.hardcoded,
                                subTitle: item.dateOfCreation?.formatDate(
                                  .ddMMyyyyHHmm,
                                ),
                              ),
                              if (item.deliveryDate != null)
                                TitleAndSubTitle(
                                  title: 'Entregue em'.hardcoded,
                                  subTitle: item.deliveryDate?.formatDate(
                                    .ddMMyyyyHHmm,
                                  ),
                                ),
                              if (item.buyer != null)
                                TitleAndSubTitle(
                                  title: 'Comprador'.hardcoded,
                                  subTitle: item.buyer?.name,
                                ),
                              if (item.supplier != null)
                                TitleAndSubTitle(
                                  title: 'Fornecedor'.hardcoded,
                                  subTitle: item.supplier?.name,
                                ),
                              if (item.requestType != null)
                                TitleAndSubTitle(
                                  title: 'Modelo pedido'.hardcoded,
                                  subTitle: item.requestType?.name,
                                ),
                              if (item.observations?.isNotEmpty ?? false)
                                TitleAndSubTitle(
                                  title: 'Observações'.hardcoded,
                                  subTitle: item.observations,
                                ),
                              TitleAndSubTitle(
                                title: 'Valor total'.hardcoded,
                                subTitle: item.totalLiquid,
                                subTitleIsPrice: true,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
