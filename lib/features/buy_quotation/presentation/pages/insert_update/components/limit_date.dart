import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controller.dart';

class LimitDate extends ConsumerWidget {
  final int enterpriseCode;
  final int code;
  const LimitDate({
    super.key,
    required this.enterpriseCode,
    required this.code,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final dateOfLimit = ref.watch(
      completeBuyQuotationsStateControllerProvider(
        enterpriseCode,
        code.toString(),
      ).select((s) => s.value?.DateOfLimit),
    );

    return SliverToBoxAdapter(
      child: Row(
        children: [
          Expanded(
            child: TitleAndSubTitle(
              title: 'Limite'.hardcoded,
              subTitle: dateOfLimit == null
                  ? null
                  : DateFormat('dd/MM/yyyy HH:mm').format(dateOfLimit),
              emptyMessage: 'Sem data de limite'.hardcoded,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: PrimaryTextButton(
                text: dateOfLimit == null
                    ? 'Inserir'.hardcoded
                    : 'Alterar'.hardcoded,
                icon: Icon(isIOS ? CupertinoIcons.calendar : Icons.date_range),
                onPressed: () async {
                  final now = DateTime.now();
                  final newDate = await GetNewDate.get(
                    minimumDate: now,
                    maximumDate: now.add(const Duration(days: 365)),
                    currentSelectedDate: dateOfLimit,
                    insertHoursAndMinutes: true,
                    context: context,
                  );

                  ref
                      .read(
                        completeBuyQuotationsStateControllerProvider(
                          enterpriseCode,
                          code.toString(),
                        ).notifier,
                      )
                      .updateValues(
                        DateOfLimit: newDate,
                        annulDateOfLimit: newDate == null,
                      );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
