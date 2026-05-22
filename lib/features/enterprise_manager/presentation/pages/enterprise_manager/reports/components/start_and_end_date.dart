import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';

class StartAndEndDate extends ConsumerWidget {
  const StartAndEndDate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.sizeOf(context).width > Breakpoint.desktop;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const _SelectPeriod(isStart: true, key: ValueKey('start')),
              gapW16,
              const _SelectPeriod(isStart: false, key: ValueKey('end')),
              if (isDesktop) ...[gapW16, _UpdateButton()],
            ],
          ),
          if (!isDesktop) ...[gapH8, _UpdateButton()],
        ],
      ),
    );
  }
}

class _UpdateButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryButton(
      text: 'Atualizar'.hardcoded,
      isLoading: ref.watch(
        appUsageStateControllerProvider.select((s) => s.isLoading),
      ),
      onPressed: () async {
        ref
            .read(appUsageStateControllerProvider.notifier)
            .loadRemoteUsageReport(
              start: ref.read(reportPeriodStateControllerProvider).$1,
              end: ref.read(reportPeriodStateControllerProvider).$2,
            );
      },
    );
  }
}

class _SelectPeriod extends ConsumerWidget {
  final bool isStart;
  const _SelectPeriod({super.key, required this.isStart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();

    return Flexible(
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            Text('Mês/ano ${isStart ? 'início' : 'final'}'.hardcoded),
            Row(
              children: [
                Flexible(
                  child: DefaultSimpleDropDown<int>(
                    padding: EdgeInsets.zero,
                    iconSize: 0,
                    onChanged: (month) => ref
                        .read(reportPeriodStateControllerProvider.notifier)
                        .update(
                          startMonth: isStart ? month : null,
                          endMonth: isStart ? null : month,
                        ),
                    items: List.generate(
                      12,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Center(child: Text('${index + 1}')),
                      ),
                    ),
                    value: ref.watch(
                      reportPeriodStateControllerProvider.select(
                        (s) => isStart ? s.$1.month : s.$2.month,
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
                        .update(
                          startYear: isStart ? year : null,
                          endYear: isStart ? null : year,
                        ),
                    items: List.generate(
                      2,
                      (index) => DropdownMenuItem(
                        value: now.year - index,
                        child: Center(child: Text('${now.year - index}')),
                      ),
                    ),
                    value: ref.watch(
                      reportPeriodStateControllerProvider.select(
                        (s) => isStart ? s.$1.year : s.$2.year,
                      ),
                    ),
                    hint: '',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
