import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return AsyncValueWidget(
      isSliver: true,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p4),
      child: Column(
        children: [
          PrimaryTextButton(
            text: schedules == null
                ? context.l10n.loadSchedules
                : context.l10n.refreshSchedules,
            platformIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.timer,
              materialIcon: Icons.timer_outlined,
            ),
            onPressed: loadSchedules,
          ),
          if (schedules?.isEmpty == true) ...[
            gapH8,
            BaseText.title(context.l10n.noSchedulesFound, color: Colors.red),
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
    return ResponsiveScrollableWidget(
      child: Card(
        margin: const EdgeInsets.only(bottom: Sizes.p8),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleAndSubTitle(
                title: context.l10n.createdBy,
                subTitle: schedule.User,
              ),
              TitleAndSubTitle(
                title: context.l10n.priceTypeLabel,
                subTitle: schedule.PriceTypeString,
              ),
              TitleAndSubTitle(
                title: context.l10n.origin,
                subTitle: schedule.OriginString,
              ),
              TitleAndSubTitle(
                title: context.l10n.changedOn,
                subTitle: schedule.Date.formatDate(DateFormatType.ddMMyyyyHHmm),
              ),
              TitleAndSubTitle(
                title: context.l10n.scheduledFor,
                subTitle: schedule.ExecutionDate.formatDate(
                  DateFormatType.ddMMyyyyHHmm,
                ),
              ),
              TitleAndSubTitle(
                title: context.l10n.newPrice,
                subTitle: schedule.OriginalPrice,
                subTitleIsPrice: true,
              ),
              if (schedule.AlteredByClass)
                TitleAndSubTitle(
                  title: context.l10n.changedByClass,
                  subTitle: null,
                ),
              if (schedule.AlteredByPackings)
                TitleAndSubTitle(
                  title: context.l10n.changedByPackings,
                  subTitle: null,
                ),
              if (schedule.AlteredByGrid)
                TitleAndSubTitle(
                  title: context.l10n.changedByGrid,

                  subTitle: null,
                ),
              if (schedule.UpdateClass)
                TitleAndSubTitle(
                  title: context.l10n.willUpdateClassPrice,
                  subTitle: null,
                ),
              if (schedule.UpdateEnterpriseOperationalGroup)
                TitleAndSubTitle(
                  title: context.l10n.willUpdateOperationalGroupPrice,
                  subTitle: null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
