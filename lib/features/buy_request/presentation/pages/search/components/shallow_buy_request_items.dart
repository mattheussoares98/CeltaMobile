import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShallowBuyRequestItems extends ConsumerWidget {
  final int enterpriseCode;
  const ShallowBuyRequestItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTapItem(int buyRequestCode) {
      context.goNamed(
        Routes.buyRequestDetails.name,
        pathParameters: {
          'enterpriseCode': enterpriseCode.toString(),
          'buyRequestCode': buyRequestCode.toString(),
        },
      );
    }

    return AsyncValueWidget(
      value: ref.watch(
        shallowBuyRequestStateControllerProvider(enterpriseCode),
      ),
      tryAgain: null,
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
          itemCount: buyRequests?.length ?? 0,
          itemBuilder: (context, index) {
            final item = buyRequests![index];

            return Card(
              clipBehavior: .hardEdge,
              child: InkWell(
                onTap: PlatformUtil.isIOS ? null : () => onTapItem(item.code),
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      if (item.personalizedCode != null)
                        BaseRichText(
                          texts: [
                            BaseText('Cód personalizado: '.hardcoded),
                            BaseText.titleMedium(
                              item.personalizedCode!.substring(0, 8).hardcoded,
                              fontWeight: FontWeight.bold,
                            ),
                            BaseText.titleMedium(
                              item.personalizedCode!.substring(8, 12).hardcoded,
                              fontWeight: FontWeight.bold,
                              color: context.theme.colorScheme.secondary,
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
                      if (PlatformUtil.isIOS)
                        Align(
                          alignment: .centerRight,
                          child: PrimaryTextButton(
                            text: 'Detalhes'.hardcoded,
                            onPressed: () => onTapItem(item.code),
                            platformIcon: const PlatformIcon(
                              cupertinoIcon: CupertinoIcons.pencil,
                              materialIcon: Icons.edit,
                            ),
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
    );
  }
}
