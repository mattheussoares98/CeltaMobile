import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../controllers/controllers.dart';

class StartAndEndDate extends ConsumerWidget {
  const StartAndEndDate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    //TODO finish this widget

    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: DefaultSimpleDropDown<int>(
                    padding: EdgeInsets.zero,
                    iconSize: 0,
                    onChanged: (month) => ref
                        .read(reportPeriodStateControllerProvider.notifier)
                        .update(startMonth: month),
                    items: List.generate(
                      12,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Center(child: Text('${index + 1}')),
                      ),
                    ),
                    value: ref.watch(
                      reportPeriodStateControllerProvider.select(
                        (s) => s.$1.month,
                      ),
                    ),
                    hint: '',
                  ),
                ),
                gapW8,
                Flexible(
                  flex: 2,
                  child: DefaultSimpleDropDown<int>(
                    padding: EdgeInsets.zero,
                    iconSize: 0,
                    onChanged: (year) => ref
                        .read(reportPeriodStateControllerProvider.notifier)
                        .update(startYear: year),
                    items: List.generate(
                      2,
                      (index) => DropdownMenuItem(
                        value: now.year - index,
                        child: Center(child: Text('${now.year - index}')),
                      ),
                    ),
                    value: ref.watch(
                      reportPeriodStateControllerProvider.select(
                        (s) => s.$1.year,
                      ),
                    ),
                    hint: '',
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Flexible(
            child: PrimaryButton(
              text: 'Gerar'.hardcoded,
              onPressed: () async {
                // final newDate = await GetNewDate.get(
                //   minimumDate: DateTime(2026, 2, 1),
                //   maximumDate: now,
                //   context: context,
                // );
                //TODO change in the controller
              },
            ),
          ),
        ],
      ),
    );
  }
}
