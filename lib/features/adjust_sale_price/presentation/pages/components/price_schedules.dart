import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class PriceSchedules extends ConsumerWidget {
  final int enterpriseCode;
  final ProductEntity product;
  const PriceSchedules({
    super.key,
    required this.enterpriseCode,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void loadSchedules() {
      ref
          .read(
            priceSchedulesStateControllerProvider(
              enterpriseCode,
              product.PLU!,
            ).notifier,
          )
          .getPriceSchedules(
            enterpriseCode: enterpriseCode,
            productCode: product.ProductCode!,
            productPackingCode: product.ProductPackingCode!,
          );
    }

    final value = ref.watch(
      priceSchedulesStateControllerProvider(enterpriseCode, product.PLU!),
    );

    ref.listen(
      priceSchedulesStateControllerProvider(enterpriseCode, product.PLU!),
      (previous, next) {
        next.showAlertDialogOnError(context);
      },
    );

    final theme = Theme.of(context);

    return AsyncValueSliverWidget(
      value: value,
      tryAgain: loadSchedules,
      data: (schedules) {
        return SliverList.builder(
          itemCount: (schedules?.length ?? 0) + 1,
          itemBuilder: (_, index) {
            if (index == 0) {
              return Column(
                children: [
                  PrimaryTextButton(
                    text: schedules == null
                        ? 'Obter agendamentos'.hardcoded
                        : 'Atualizar agendamentos'.hardcoded,
                    icon: Icon(
                      theme.platform == TargetPlatform.iOS
                          ? CupertinoIcons.timer
                          : Icons.timer_outlined,
                    ),
                    onPressed: loadSchedules,
                  ),
                  if (schedules?.isEmpty == true) ...[
                    gapH8,
                    Text(
                      'Nenhum foi agendamento encontrado'.hardcoded,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ],
              );
            }

            final schedule = schedules![index - 1];

            return ResponsiveScrollableWidget(
              padding: Sizes.p4,
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleAndSubTitle(
                        title: 'Criado por '.hardcoded,
                        subTitle: schedule.User,
                      ),
                      TitleAndSubTitle(
                        title: 'Tipo de preço '.hardcoded,
                        subTitle: schedule.PriceTypeString,
                      ),
                      TitleAndSubTitle(
                        title: 'Origem '.hardcoded,
                        subTitle: schedule.OriginString,
                      ),
                      TitleAndSubTitle(
                        title: 'Alterado em '.hardcoded,
                        subTitle: DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(schedule.Date),
                      ),
                      TitleAndSubTitle(
                        title: 'Será executado em '.hardcoded,
                        subTitle: DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(schedule.ExecutionDate),
                      ),
                      TitleAndSubTitle(
                        title: 'Novo preço '.hardcoded,
                        subTitle: schedule.OriginalPrice,
                        subTitleIsPrice: true,
                      ),
                      if (schedule.AlteredByClass)
                        TitleAndSubTitle(
                          title: "Alterado via classe".hardcoded,
                          subTitle: null,
                        ),
                      if (schedule.AlteredByPackings)
                        TitleAndSubTitle(
                          title: "Alterado por embalagens".hardcoded,
                          subTitle: null,
                        ),
                      if (schedule.AlteredByGrid)
                        TitleAndSubTitle(
                          title: "Alterado por grade".hardcoded,

                          subTitle: null,
                        ),
                      if (schedule.UpdateClass)
                        TitleAndSubTitle(
                          title: "Vai alterar o preço da classe".hardcoded,
                          subTitle: null,
                        ),
                      if (schedule.UpdateEnterpriseOperationalGroup)
                        TitleAndSubTitle(
                          title:
                              "Vai alterar preço do agrupamento operacional das empresas"
                                  .hardcoded,
                          subTitle: null,
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
