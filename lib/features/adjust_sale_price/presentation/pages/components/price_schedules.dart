import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
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
              product.PLU,
            ).notifier,
          )
          .getPriceSchedules(
            enterpriseCode: enterpriseCode,
            productCode: product.ProductCode,
            productPackingCode: product.ProductPackingCode,
          );
    }

    final value = ref.watch(
      priceSchedulesStateControllerProvider(enterpriseCode, product.PLU),
    );

    ref.listen(
      priceSchedulesStateControllerProvider(enterpriseCode, product.PLU),
      (previous, next) {
        next.showAlertDialogOnError(context);
      },
    );

    final theme = Theme.of(context);

    return AsyncValueSliverWidget(
      value: value,
      tryAgain: loadSchedules,
      data: (schedules) {
        if (schedules.isEmpty) {
          return SliverToBoxAdapter(
            child: PrimaryTextButton(
              text: 'Obter agendamentos'.hardcoded,
              icon: Icon(
                theme.platform == TargetPlatform.iOS
                    ? CupertinoIcons.timer
                    : Icons.timer,
              ),
              onPressed: loadSchedules,
            ),
          );
        }
        return SliverList.builder(
          itemCount: schedules.length,
          itemBuilder: (_, index) {
            final schedule = schedules[index];

            return Column(
              children: [
                Text("Code ${schedule.Code}"),
                Text("FatherCode ${schedule.FatherCode}"),
                Text("BrotherCode ${schedule.BrotherCode}"),
                Text("PriceType ${schedule.PriceType}"),
                Text("Origin ${schedule.Origin}"),
                Text("User ${schedule.User}"),
                Text("PriceTypeString ${schedule.PriceTypeString}"),
                Text("OriginString ${schedule.OriginString}"),
                Text("OfferSchedule ${schedule.OfferSchedule}"),
                Text("Date ${schedule.Date}"),
                Text("ExecutionDate ${schedule.ExecutionDate}"),
                Text("ExecutedDate ${schedule.ExecutedDate}"),
                Text("OriginalPrice ${schedule.OriginalPrice}"),
                Text("Price ${schedule.Price}"),
                Text("LastPrice ${schedule.LastPrice}"),
                Text("RoundedPrice ${schedule.RoundedPrice}"),
                Text(
                  "AlteredByEnterpriseGroup ${schedule.AlteredByEnterpriseGroup}",
                ),
                Text("AlteredByClass ${schedule.AlteredByClass}"),
                Text("AlteredByPackings ${schedule.AlteredByPackings}"),
                Text("AlteredByGrid ${schedule.AlteredByGrid}"),
                Text("UpdateClass ${schedule.UpdateClass}"),
                Text(
                  "UpdateEnterpriseOperationalGroup ${schedule.UpdateEnterpriseOperationalGroup}",
                ),
                Text("IsFather ${schedule.IsFather}"),
                Text("IsBrother ${schedule.IsBrother}"),
                Text("IsExecuted ${schedule.IsExecuted}"),
                Text("IsFinished ${schedule.IsFinished}"),
              ],
            );
          },
        );
      },
    );
  }
}
