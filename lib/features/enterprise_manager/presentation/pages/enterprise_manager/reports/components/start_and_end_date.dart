import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../localization/string_hardcoded.dart';

class StartAndEndDate extends ConsumerWidget {
  const StartAndEndDate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO create separated controller for selected period and control the minimum date

    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: PrimaryButton(
              text: 'Data início'.hardcoded,
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
          const Spacer(),
          Flexible(
            child: PrimaryButton(
              text: 'Data fim'.hardcoded,
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
