import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final dateOfLimit = ref.watch(
      completeBuyQuotationsStateControllerProvider(
        enterpriseCode,
        code.toString(),
      ).select((s) => s.value?.DateOfLimit),
    );

    return SliverToBoxAdapter(
      child: RepaintBoundary(
        child: Row(
          children: [
            Expanded(
              child: TitleAndSubTitle(
                title: context.l10n.deadline,
                subTitle: dateOfLimit?.formatDate(DateFormatType.ddMMyyyyHHmm),
                emptyMessage: context.l10n.noDeadline,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: PrimaryTextButton(
                  text: dateOfLimit == null
                      ? context.l10n.insert
                      : context.l10n.change,
                  platformIcon: const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.calendar,
                    materialIcon: Icons.date_range,
                  ),
                  onPressed: () async {
                    final now = DateTime.now();
                    final newDate = await GetNewDate.get(
                      minimumDate: now,
                      maximumDate: now.add(const Duration(days: 365)),
                      currentSelectedDate: dateOfLimit,
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
      ),
    );
  }
}
