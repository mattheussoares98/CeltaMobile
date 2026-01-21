import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';
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
    final provider = priceSchedulesStateControllerProvider(
      enterpriseCode,
      product.PLU!,
    );

    void loadSchedules() {
      ref
          .read(provider.notifier)
          .getPriceSchedules(
            enterpriseCode: enterpriseCode,
            productCode: product.ProductCode!,
            productPackingCode: product.ProductPackingCode!,
          );
    }

    ref.listen(provider, (previous, next) {
      next.showAlertDialogOnError(context);
    });

    return AsyncValueSliverWidget(
      value: ref.watch(provider),
      tryAgain: loadSchedules,
      data: (schedules) {
        return SliverList.builder(
          itemCount: (schedules?.length ?? 0) + 1,
          itemBuilder: (_, index) {
            if (index == 0) {
              return _LoadSchedules(
                key: const ValueKey('load_schedules'),
                loadSchedules: loadSchedules,
                schedules: schedules,
              );
            }

            final schedule = schedules![index - 1];

            return _ScheduleItem(
              key: ValueKey('schedule_${schedule.Code}'),
              schedule: schedule,
            );
          },
        );
      },
    );
  }
}

class _LoadSchedules extends StatelessWidget {
  final VoidCallback loadSchedules;
  final List<PriceScheduleEntity>? schedules;
  const _LoadSchedules({
    super.key,
    required this.loadSchedules,
    required this.schedules,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p4),
      child: Column(
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
              'Nenhum agendamento foi encontrado'.hardcoded,
              style: theme.textTheme.titleSmall?.copyWith(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final PriceScheduleEntity schedule;
  const _ScheduleItem({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return ResponsiveScrollableWidget(
      child: Card(
        margin: const EdgeInsets.only(bottom: Sizes.p8),
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
                subTitle: dateFormat.format(schedule.Date),
              ),
              TitleAndSubTitle(
                title: 'Será executado em '.hardcoded,
                subTitle: dateFormat.format(schedule.ExecutionDate),
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
  }
}
