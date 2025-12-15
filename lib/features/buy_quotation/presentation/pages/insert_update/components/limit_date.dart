import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controller.dart';

class LimitDate extends ConsumerWidget {
  final BuyQuotationEntity buyQuotation;
  final int enterpriseCode;
  const LimitDate({
    super.key,
    required this.buyQuotation,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return SliverToBoxAdapter(
      child: Row(
        children: [
          Expanded(
            child: TitleAndSubTitle(
              title: 'Data limite'.hardcoded,
              subTitle: buyQuotation.DateOfLimit == null
                  ? null
                  : DateFormat('dd/MM/yyyy').format(buyQuotation.DateOfLimit!),
              emptyMessage: 'Sem data de limite'.hardcoded,
            ),
          ),
          PrimaryTextButton(
            text: buyQuotation.DateOfLimit == null
                ? 'Inserir'.hardcoded
                : 'Alterar'.hardcoded,
            icon: Icon(isIOS ? CupertinoIcons.calendar : Icons.date_range),
            onPressed: () async {
              final now = DateTime.now();
              final newDate = await GetNewDate.get(
                minimumDate: now,
                maximumDate: now.add(const Duration(days: 365)),
                currentSelectedDate: buyQuotation.DateOfLimit,
                insertHoursAndMinutes: false,
                context: context,
              );

              ref
                  .read(
                    completeBuyQuotationsStateControllerProvider(
                      enterpriseCode,
                      buyQuotation.Code.toString(),
                    ).notifier,
                  )
                  .updateValues(
                    DateOfLimit: newDate,
                    annulDateOfLimit: newDate == null,
                  );
            },
          ),
        ],
      ),
    );
  }
}
